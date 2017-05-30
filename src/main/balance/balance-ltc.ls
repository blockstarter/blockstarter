require! {
    \request
    \big.js
}

iserror = (require \../iserror.js) \http://ltc.blockr.io

#unconfirmed
#http://ltc.blockr.io/api/v1/address/unconfirmed/LajyQBeZaBA1NkZDeY8YT5RYYVRkXMvb2T

module.exports = (key, callback)->
    err, response, body <-! request "http://ltc.blockr.io/api/v1/address/info/#{key}"
    return callback null if iserror err, "Failed to get balance of LTC address #{key}"
    data = JSON.parse body
    #console.log \ltc, key,  data.data.balance
    callback err, big(data.data.balance)