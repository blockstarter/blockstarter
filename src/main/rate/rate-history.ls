require! {
    \request
    \./rate-cache.js
    \moment
    \prelude-ls : \p
}

iserror = (require \../iserror.js) \https://poloniex.com

build-url = (pair, end)-->
  "https://poloniex.com/public?command=returnTradeHistory&currencyPair=#{pair}&end=#{end}" 

url =
    btc_eth  : build-url \BTC_ETH
    usdt_eth : build-url \USDT_ETH
    usdt_btc : build-url \USDT_BTC

module.exports = (ts, cb)-->
    extract-val = (arr)->
        arr |> p.filter (.type is \sell) 
            |> p.sort-by (.globalTradeID)
            |> p.reverse
            |> p.head
            |> (-> it?rate)
    get-val = JSON.parse >> extract-val 
    err, response, body <-! request url.btc_eth ts
    return cb err if err?
    btc_eth = get-val body
    err, response, body <-! request url.usdt_eth ts
    return cb err if err?
    usdt_eth = get-val body
    err, response, body <-! request url.usdt_btc ts
    return cb err if err?
    usdt_btc = get-val body
    
    model =
      ETH:
        BTC: btc_eth
        CHF: usdt_eth
    cb err, model
    