# Blockstarter Rate History built for Aeternity 

# Developers Alex Siman and Andrey Stegno



require! {
    \request
    \./rate-cache.js
    \moment
    \prelude-ls : \p
    \big.js
}

iserror = (require \../iserror.js) \https://poloniex.com

build-url = (pair)->
  "https://poloniex.com/public?command=returnTradeHistory&currencyPair=#{pair}"

each-minute-quarter = 15 * 60

round-minute-quarter-trade = (trade)->
    round-minute-quarter \ceil , trade.date

round-minute-quarter = (direction, date)-->
    plus = if direction is \ceil then 1 else 0
    ts = date-to-ts date
    parse-int(ts / each-minute-quarter + 1) * each-minute-quarter

observers = []

notify = (name, data)->
    observers |> p.filter (.0 is name) 
              |> p.map (.1) 
              |> p.each (-> it data)

export $off = (cb)->
    if not cb?
       observers.length = 0
    index =
        observers.map(-> it.1).index-of(cb) > -1
    if index > -1
       observers.splice index, 1
    { $off }

export $on = (name, cb)->
    observers.push [name, cb]
    { $on }


get-string = (date)->
    | date.match(/^[0-9]+$/) => parse-int date
    | _ => moment(date.replace(' ', \T) + \Z).unix!

date-to-ts = (date) ->
   switch typeof! date 
     case \String then get-string date
     case \Number then date
     case \Date  then parse-int(date.get-time! / 1000)
     case \Undefined then null
     case \Null then null
     else "Type of date '#{typeof! date}' is not supported"

calc-avg-trade = (accum, t) ->
    accum.sumOfRxA = accum.sumOfRxA.plus new big(t.rate).times(t.amount)
    accum.sumOfA = accum.sumOfA.plus t.amount
    accum

calc-avg = (trades)->
    accum = 
        sumOfRxA: new big 0
        sumOfA: new big 0
    result = 
        trades |> p.foldl calc-avg-trade, accum
    result.sumOfRxA.div(result.sumOfA).to-string!

# start-campaign-date : 1496063101

aggregate = (collector, trade)->
    collector.unique = collector.unique ? {}
    return collector if trade.avg?
    return collector if collector.unique[trade.globalTradeID]?
    collector.unique[trade.globalTradeID] = yes
    group = round-minute-quarter-trade trade
    collector[group] = collector[group] ? []
    collector[group].push trade
    collector
    
calc-all-avgs = (collector)->
    delete collector.unique
    for key in Object.keys(collector)
        collector[key] = calc-avg collector[key]
    collector

export load-rates = (config, cb)-->
    err, items <-! upload-rates config
    return cb err if err?
    start = new Date!
    notify \aggregation-start, { items.length, start}
    result =
        items |> p.foldl aggregate, {}
              |> calc-all-avgs
    end = new Date!
    notify \aggregation-stop, { end, duration: start.get-time! - end.get-time! }
    cb null, result

upload-rates = ({start-campaign-date, currency-pair, to-date}, cb)-->
   return cb "Input Error" if not start-campaign-date? or not currency-pair? or not to-date?
   url = build-url currency-pair
   start_campaign_ts = date-to-ts start-campaign-date
   to-ts = date-to-ts to-date
   current-url = "#{url}&end=#{to-ts + each-minute-quarter}"
   notify \load-rates, {start-campaign-date, currency-pair, to-date, current-url}
   err, response, body <-! request current-url
   return cb err if err?
   items = JSON.parse body
   return cb items.error if items.error?
   return cb null, [] if items.length is 0
   last = items[items.length - 1]
   next-ts = last.date
   return cb null, items if start_campaign_ts > to-ts
   err, next-items <-! upload-rates {start-campaign-date, currency-pair, to-date: next-ts}
   return cb "Error for #{url}/#{next-ts}: #{err}" if err?
   all-items = 
      items ++ next-items
   cb null, all-items

export rate-index = {}

export get-rate-index = (currency-pair)->
   rate-index[currency-pair.to-lower-case!]
   
export set-rate-index = (currency-pair, rate-index)->
   rate-index[currency-pair.to-lower-case!]  = rate-index


export create-rate-index = ({start-campaign-date, currency-pair, to-date}, cb)->
   rate-index.running = rate-index.running ? {}
   return cb \Running if rate-index.running[currency-pair.to-lower-case!]
   notify \create-index-start, { start-campaign-date, currency-pair, to-date }
   rate-index.running[currency-pair.to-lower-case!] = yes
   cb-wrap = (err, res)->
     rate-index.running[currency-pair.to-lower-case!] = no
     notify \create-index-end, { start-campaign-date, currency-pair, to-date }
     cb err, res
   err, rates <-! load-rates {start-campaign-date, currency-pair, to-date}
   return cb-wrap err if err?
   ri = rate-index[currency-pair.to-lower-case!] = rates
   #ensure-index = ([ts, avg])-> ri[ts] = avg
   #rates |> p.obj-to-pairs |> p.each ensure-index
   cb-wrap null, rates

export get-rate = (ts)->
    btc-eth = get-rate-by-pair ts, \BTC_ETH
    usdt-eth = get-rate-by-pair ts, \USDT_ETH
    ETH: 
        BTC: btc-eth
        CHF: usdt-eth

get-rate-by-pair = (ts, currency-pair)->
    rounded = round-minute-quarter \floor, ts
    rate-index[currency-pair.to-lower-case!]?[rounded]
    
get-or-load-rate = ({start-campaign-date, ts, currency-pair}, cb) ->
    rate = get-rate {ts, currency-pair}
    return cb null, rate if rate?
    err <-! create-rate-index {start-campaign-date, ts, currency-pair}
    return cb err if err?
    rate = get-rate {ts, currency-pair}
    cb null, rate