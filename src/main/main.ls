export 
  new-addr:
    eth: require \./new-addr/new-addr-eth.js
    btc: require \./new-addr/new-addr-btc.js
    ltc: require \./new-addr/new-addr-ltc.js
  sign:
    eth: require \./sign/sign-eth.js
    btc: require \./sign/sign-btc.js
    ltc: require \./sign/sign-ltc.js
  balance:
    ltc: require \./balance/balance-ltc.js
    btc: require \./balance/balance-btc.js
    eth: require \./balance/balance-eth.js
  rate:
    ltc: require(\./rate/rate.js) \LTC
    btc: require(\./rate/rate.js) \BTC
    eth: require(\./rate/rate.js) \ETH
    