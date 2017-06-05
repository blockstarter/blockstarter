require! { 
    \expect 
    \../main/main.js
    \big.js
    \prelude-ls : \p
    \moment
    \fs
}

all-coins = [\eth, \btc, \ltc]

run <-! describe \BigRate

_ = JSON.stringify


save = (currency-pair, rates)->
  tranform = ([ts, val])->
    u = moment.unix(ts).utc!.to-string!
    [u, val]
  human = 
    rates |> p.obj-to-pairs |> p.map(tranform) |> p.pairs-to-obj
  fs.write-file-sync "./logs/#{currency-pair}.json", JSON.stringify(rates, null, 2)
  fs.write-file-sync "./logs/#{currency-pair}-human.json", JSON.stringify(human, null, 2)

it \big-rate-index-create_BTC_ETH, (done)->
  @timeout 120 * 1000
  start-campaign-date = 1496063101
  to-date = new Date!
  currency-pair = \BTC_ETH
  get-rates = ->
    main.rate-history.get-rate-index(currency-pair)
  main.rate-history
    .$on \create-index-start, ({start-campaign-date})->
      console.log \create-index-start, start-campaign-date
    .$on \load-rates, ({start-campaign-date, to-date, current-url})->
      console.log \load-rates, start-campaign-date, current-url, start-campaign-date > to-date
    .$on \aggregation-start, ({start, length})->
      console.log \aggregation-start, start, length
    .$on \aggregation-stop, ({end, duration})->
      console.log \aggregation-stop, end, duration
    .$on \create-index-end, ({start-campaign-date})->
      console.log \create-index-end, start-campaign-date
  err, rates <-! main.rate-history.create-rate-index {start-campaign-date, currency-pair, to-date}
  expect err .to-be null
  expect get-rates! .to-be rates
  save currency-pair, rates
  main.rate-history.$off!
  done!
  
it \big-rate-index-create_USDT_ETH, (done)->
  @timeout 120 * 1000
  start-campaign-date = 1496063101
  to-date = new Date!
  currency-pair = \USDT_ETH
  get-rates = ->
    main.rate-history.get-rate-index(currency-pair)
  main.rate-history
    .$on \create-index-start, ({start-campaign-date})->
      console.log \create-index-start, start-campaign-date
    .$on \load-rates, ({start-campaign-date, to-date,  current-url})->
      console.log \load-rates, start-campaign-date, current-url, start-campaign-date > to-date
    .$on \aggregation-start, ({start, length})->
      console.log \aggregation-start, start, length
    .$on \aggregation-stop, ({end, duration})->
      console.log \aggregation-stop, end, duration
    .$on \create-index-end, ({start-campaign-date})->
      console.log \create-index-end, start-campaign-date
  err, rates <-! main.rate-history.create-rate-index {start-campaign-date, currency-pair, to-date}
  expect err .to-be null
  expect get-rates! .to-be rates
  save currency-pair, rates
  main.rate-history.$off!
  done!

it \rates-cryptocompare, (done)->
  @timeout 120 * 1000
  coins = all-coins
  check-rate = (coin, cb)->
      provider = main.rate[coin]
      err, rate <-! provider!
      expect err .to-be null
      expect rate .to-be-a \number
      cb null, rate
  check-rates = ([head, ...tail], cb)->
    return cb null if not head?
    err <-! check-rate head
    expect(err).to-be null
    check-rates tail, cb
  check-rates coins, done