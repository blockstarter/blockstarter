require! {
    \request
    \./rate-cache.js
}

iserror = (require \../iserror.js) 'https://min-api.cryptocompare.com'

module.exports = (currency, cb)-->
    err, response, body <-! request "https://min-api.cryptocompare.com/data/price?fsym=#{currency}&tsyms=USD"
    return cb err if iserror err, "Failed to get rate for #{currency}/USD"
    try 
        usd-rate = (JSON.parse body).USD
        rate-cache.update currency, usd-rate
        cb null, usd-rate
    catch err
        cb err