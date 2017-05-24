balance =
    ltc: require \./balance/balance-ltc.js
    btc: require \./balance/balance-btc.js
    eth: require \./balance/balance-eth.js
calc = ->
    ltc: require(\./calc/calc.js) balance.ltc
    btc: require(\./calc/calc.js) balance.btc
    eth: require(\./calc/calc.js) balance.eth
rate =
    ltc: require(\./rate/rate.js) \LTC
    btc: require(\./rate/rate.js) \BTC
    eth: require(\./rate/rate.js) \ETH
sign =
    eth: require \./sign/sign-eth.js
    btc: require \./sign/sign-btc.js
    ltc: require \./sign/sign-ltc.js
new-addr =
    eth: require \./new-addr/new-addr-eth.js
    btc: require \./new-addr/new-addr-btc.js
    ltc: require \./new-addr/new-addr-ltc.js
total = require(\./total/total.js) calc
export {
  new-addr
  sign
  balance
  rate
  calc
  total
}
  
    