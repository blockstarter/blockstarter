require! { 
    \expect 
    \../main/main.js
    \big.js
    \prelude-ls : \p
    \moment
}

all-coins = [\eth, \btc, \ltc]

run <-! describe \Rate

_ = JSON.stringify


it \set-rate-index, (done)->
  obj = "test"
  main.rate-history.set-rate-index \TEST, obj
  another = main.rate-history.get-rate-index \TEST
  expect obj is "test" .to-be yes
  done!
  

it \rate-index-create, (done)->
  @timeout 90000
  to-date = new Date!.get-time! / 1000
  start-campaign-date = to-date - (20 * 60 * 60) # 20 hours before
  buy-or-sell = \buy
  currency-pair = \BTC_ETH
  keys = ->
    Object.keys(main.rate-history.rate-index).length
  expect keys! .to-be 0
  err <-! main.rate-history.create-rate-index {start-campaign-date, buy-or-sell, currency-pair, to-date}
  expect err .to-be null
  expect keys! .to-be-greater-than 0
  done!

it \use-index, (done)->
  keys = ->
    Object.keys(main.rate-history.rate-index).length
  expect keys! .to-be-greater-than 0
  done!
  
it \validate-index, (done)->
  index = main.rate-history.rate-index
  console.log index
  done!

return

it \rate-history-0, (done)->
  @timeout 25000
  err, result <-! main.rate-history.get-rate "2017-05-28 4:30:00"
  expect _ result .to-be _ { ETH: { BTC: '0.07846300', CHF: '167.00000000' } }
  done!

it \rate-history-1, (done)->
  @timeout 15000
  err, result <-! main.rate-history.get-rate "2017-05-30 4:30:00"
  expect _ result .to-be _ { ETH: { BTC: '0.08900010', CHF: '199.50000001' } }
  done!

it \rate-history-2, (done)->
  @timeout 15000
  err, result <-! main.rate-history.get-rate "2017-06-01 4:30:00"
  expect _ result .to-be _ { ETH: { BTC: '0.09699600', CHF: '219.46044850' } }
  done!

it \rate-history-3, (done)->
  @timeout 15000
  err, result <-! main.rate-history.get-rate "2017-06-01 22:30:00"
  expect _ result .to-be _ { ETH: { BTC: '0.09276898', CHF: '211.50000000' } }
  done!

it \rate-history-3-duplicate, (done)->
  @timeout 15000
  err, result <-! main.rate-history.get-rate "2017-06-01 22:30:00"
  expect _ result .to-be _ { ETH: { BTC: '0.09276898', CHF: '211.50000000' } }
  done!

it \rate-history-4, (done)->
  @timeout 8000
  err, result <-! main.rate-history.get-rate "2017-06-01 23:30:00"
  expect _ result .to-be _ { ETH: { BTC: '0.09198971', CHF: '211.30000058' } }
  done!

it \rate-history-4-duplicate, (done)->
  @timeout 8000
  err, result <-! main.rate-history.get-rate "2017-06-01 23:30:00"
  expect _ result .to-be _ { ETH: { BTC: '0.09198971', CHF: '211.30000058' } }
  done!


it \rates-cryptocompare, (done)->
  @timeout 5000
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