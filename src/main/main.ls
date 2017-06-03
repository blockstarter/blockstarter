balance =
    ltc: require \./balance/balance-ltc.js
    btc: require \./balance/balance-btc.js
    eth: require \./balance/balance-eth/balance-eth.js
calc = ->
    ltc: require(\./calc/calc.js) balance~ltc
    btc: require(\./calc/calc.js) balance~btc
    eth: require(\./calc/calc.js) balance~eth
rate =
    ltc: require(\./rate/rate.js) \LTC
    btc: require(\./rate/rate.js) \BTC
    eth: require(\./rate/rate.js) \ETH

rate-history = require \./rate/rate-history.js

sign =
    eth: require \./sign/sign-eth.js
    btc: require \./sign/sign-btc.js
    ltc: require \./sign/sign-ltc.js
new-addr =
    eth: require \./new-addr/new-addr-eth.js
    btc: require \./new-addr/new-addr-btc.js
    ltc: require \./new-addr/new-addr-ltc.js
new-addr-hide =
    require \./new-addr-hide/new-addr-hide.js

encrypt-private-key = require \./encrypt-private-key.js    

total = require(\./total/total.js) calc
export {
  encrypt-private-key
  new-addr
  sign
  balance
  rate
  calc
  total
  new-addr-hide
  rate-history
}
  
    