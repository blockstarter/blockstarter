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
    index =
        observers.map(-> it.1).index-of(cb) > -1
    if index > -1
       observers.splice index, 1

export $on = (name, cb)->
    observers.push [name, cb]

date-to-ts = (date) ->
   switch typeof! date 
     case \String then moment(date.replace(' ', \T) + \Z).unix!
     case \Number then date
     case \Date  then parse-int(date.get-time! / 1000)
     case \Undefined then null
     case \Null then null
     else "Type of date '#{typeof! date}' is not supported"

calc-avg-trade = (accum, t) ->
    accum.sumOfRxA = accum.sumOfRxA.plus new big(t.rate).times(t.amount)
    accum.sumOfA = accum.sumOfA.plus t.amount
    accum

calc-avg = ([ts, trades])->
    accum = 
        sumOfRxA: new big 0
        sumOfA: new big 0
    result = 
        trades |> p.foldl calc-avg-trade, accum
    avg = result.sumOfRxA.div(result.sumOfA).to-string!
    {ts, avg}


# start-campaign-date : 1496063101

load-rates = ({start-campaign-date, currency-pair, to-date}, cb)-->
   return cb "Input Error" if not start-campaign-date? or not currency-pair? or not to-date?
   url = build-url currency-pair
   start_campaign_ts = date-to-ts start-campaign-date
   to-ts = date-to-ts to-date
   current-url = "#{url}&end=#{to-ts}"
   notify \load-rates, {start-campaign-date, currency-pair, to-date, current-url}
   err, response, body <-! request current-url
   return cb err if err?
   items = JSON.parse body
   return cb items.error if items.error?
   return cb null, [] if items.length is 0
   last = items[items.length - 1]
   next-ts = last.date
   return cb null, items if start_campaign_ts > to-ts
   err, next-items <-! load-rates {start-campaign-date, currency-pair, to-date: next-ts}
   return cb "Error for #{url}/#{next-ts}: #{err}" if err?
   all-items = 
      items |> (-> it ++ next-items)
            |> p.unique-by (.globalTradeID)
            |> p.filter (-> not it.avg?)
            |> p.group-by round-minute-quarter-trade 
            |> p.obj-to-pairs
            |> p.map calc-avg
   cb null, all-items

export rate-index = {}

export create-rate-index = ({start-campaign-date, currency-pair, to-date}, cb)->
   create-rate-index.running = create-rate-index.running ? {}
   return cb \Running if create-rate-index.running[currency-pair]
   notify \create-index-start, { start-campaign-date, currency-pair, to-date }
   create-rate-index.running[currency-pair] = yes
   cb-wrap = (err, res)->
     create-rate-index.running[currency-pair] = no
     notify \create-index-end, { start-campaign-date, currency-pair, to-date }
     cb err, res
   err, rates <-! load-rates {start-campaign-date, currency-pair, to-date}
   return cb-wrap err if err?
   ri = rate-index[currency-pair] = rate-index[currency-pair] ? {}
   ensure-index = ({ts, avg})-> ri[ts] = avg
   rates |> p.each ensure-index
   cb-wrap null


export get-rate = (ts)->
    btc-eth = get-rate-by-pair ts, \BTC_ETH
    usdt-eth = get-rate-by-pair ts, \USDT_ETH
    ETH: 
        BTC: btc-eth
        CHF: usdt-eth
    
get-rate-by-pair = (ts, currency-pair)->
    rounded = round-minute-quarter \ceil, ts
    rate-index[currency-pair]?[rounded]
    
get-or-load-rate = ({start-campaign-date, ts, currency-pair}, cb) ->
    rate = get-rate {ts, currency-pair}
    return cb null, rate if rate?
    err <-! create-rate-index {start-campaign-date, ts, currency-pair}
    return cb err if err?
    rate = get-rate {ts, currency-pair}
    cb null, rate