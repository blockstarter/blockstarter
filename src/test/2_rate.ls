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



it \rate-index-create_BTC_ETH, (done)->
  @timeout 90000
  to-date = moment('2017-06-01 12:00:00', 'YYYY-MM-DD hh:mm:ss').to-date!.get-time! / 1000
  start-campaign-date = to-date - (20 * 60 * 60)
  currency-pair = \BTC_ETH
  keys = ->
    Object.keys(main.rate-history.get-rate-index(currency-pair)).length
  expect keys! .to-be 0
  err <-! main.rate-history.create-rate-index {start-campaign-date, currency-pair, to-date}
  expect err .to-be null
  expect keys! .to-be-greater-than 0
  done!
  
it \rate-index-create_USDT_ETH, (done)->
  @timeout 90000
  to-date = moment('2017-06-01 12:00:00', 'YYYY-MM-DD hh:mm:ss').to-date!.get-time! / 1000
  start-campaign-date = to-date - (20 * 60 * 60)
  currency-pair = \USDT_ETH
  keys = ->
    Object.keys(main.rate-history.get-rate-index(currency-pair)).length
  expect keys! .to-be 0
  err <-! main.rate-history.create-rate-index {start-campaign-date, currency-pair, to-date}
  expect err .to-be null
  expect keys! .to-be-greater-than 0
  done!

it \use-index, (done)->
  keys = ->
    Object.keys(main.rate-history.get-rate-index(\USDT_ETH)).length
  expect keys! .to-be-greater-than 0
  done!
  
it \validate-index, (done)->
  index = main.rate-history.get-rate-index(\BTC_ETH)
  expect index['1496279700'] .to-be '0.09702201288228346'
  expect index['1496280600'] .to-be '0.09675693987362170457'
  expect index['1496281500'] .to-be '0.09592861752295677433'
  expect index['1496282400'] .to-be '0.09548791189391519931'
  expect index['1496283300'] .to-be '0.09716204780483330175'
  expect index['1496284200'] .to-be '0.09672959373174968323'
  expect index['1496285100'] .to-be '0.09714683235457762815'
  expect index['1496286000'] .to-be '0.09849250302780128774'
  expect index['1496286900'] .to-be '0.0987041884630781329'
  expect index['1496287800'] .to-be '0.09920800627020897573'
  expect index['1496288700'] .to-be '0.09835841956083734385'
  expect index['1496289600'] .to-be '0.09767701194639689776'
  expect index['1496290500'] .to-be '0.0978859470654553916'
  expect index['1496291400'] .to-be '0.0973667326462719241'
  expect index['1496292300'] .to-be '0.09709661343155509171'
  expect index['1496293200'] .to-be '0.09677887507421285383'
  expect index['1496294100'] .to-be '0.09750921687975925812'
  expect index['1496295000'] .to-be '0.09745885041498921889'
  expect index['1496295900'] .to-be '0.09752093052299601421'
  expect index['1496296800'] .to-be '0.09776152047870758321'
  expect index['1496297700'] .to-be '0.0976395299242219353'
  expect index['1496298600'] .to-be '0.09767165595510213404'
  expect index['1496299500'] .to-be '0.09851383741323430677'
  expect index['1496300400'] .to-be '0.09789061751187147101'
  expect index['1496301300'] .to-be '0.09710277061138622951'
  expect index['1496302200'] .to-be '0.09704065595624124193'
  expect index['1496303100'] .to-be '0.0971213415668452932'
  expect index['1496304000'] .to-be '0.09623592708655126199'
  expect index['1496304900'] .to-be '0.09533368734198909928'
  expect index['1496305800'] .to-be '0.09389105047247266473'
  expect index['1496306700'] .to-be '0.09430878867405417301'
  expect index['1496307600'] .to-be '0.09476392182510527175'
  expect index['1496308500'] .to-be '0.09434161402172733173'
  expect index['1496309400'] .to-be '0.09440318693300964315'
  expect index['1496310300'] .to-be '0.09422987749686263119'
  expect index['1496311200'] .to-be '0.09437541993288284248'
  expect index['1496312100'] .to-be '0.09423480179700469022'
  expect index['1496313000'] .to-be '0.0950620572310785529'
  expect index['1496313900'] .to-be '0.09572315159116917355'
  expect index['1496314800'] .to-be '0.09609890405986908839'
  expect index['1496315700'] .to-be '0.09521569092462984114'
  expect index['1496316600'] .to-be '0.09466042015927515673'
  expect index['1496317500'] .to-be '0.09429862663102370146'
  expect index['1496318400'] .to-be '0.09330860236293775517'
  done!


it \rate-history-0, (done)->
  @timeout 25000
  result = main.rate-history.get-rate "2017-06-01 11:00:00"
  expect _ result .to-be _ { ETH: { BTC: '0.09521569092462984114', CHF: '221.35216978046772883573' } }
  done!

it \rate-history-1, (done)->
  @timeout 15000
  result = main.rate-history.get-rate "2017-06-01 10:00:00"
  expect _ result .to-be _ { ETH: { BTC: '0.09423480179700469022', CHF: '218.96725721500082564989' } }
  done!

it \rate-history-2, (done)->
  @timeout 15000
  result = main.rate-history.get-rate "2017-06-01 09:00:00"
  expect _ result .to-be _ { ETH: { BTC: '0.09434161402172733173', CHF: '220.11719164516814684538' } }
  done!

it \rate-history-3, (done)->
  @timeout 15000
  result = main.rate-history.get-rate "2017-06-01 08:00:00"
  expect _ result .to-be _ { ETH: { BTC: '0.09533368734198909928', CHF: '222.15297001160537129368' } }
  done!

it \rate-history-3-duplicate, (done)->
  @timeout 15000
  result = main.rate-history.get-rate "2017-06-01 08:00:00"
  expect _ result .to-be _ { ETH: { BTC: '0.09533368734198909928', CHF: '222.15297001160537129368' } }
  done!

it \rate-history-4, (done)->
  @timeout 8000
  result = main.rate-history.get-rate "2017-06-01 06:00:00"
  expect _ result .to-be _ { ETH: { BTC: '0.0976395299242219353', CHF: '223.83178639860049175969' } }
  done!

it \rate-history-4-duplicate, (done)->
  @timeout 8000
  result = main.rate-history.get-rate "2017-06-01 06:00:00"
  expect _ result .to-be _ { ETH: { BTC: '0.0976395299242219353', CHF: '223.83178639860049175969' } }
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