request = require \request
big-number = require \big.js
iserror = require \../iserror.js

#unconfirmed
#http://ltc.blockr.io/api/v1/address/unconfirmed/LajyQBeZaBA1NkZDeY8YT5RYYVRkXMvb2T

module.exports = (key, callback)->
    err, response, body <-! request "http://ltc.blockr.io/api/v1/address/info/#{key}"
    return callback null if iserror err, "Balance ltc #{key}"
    data = JSON.parse body
    #console.log \ltc, key,  data.data.balance
    callback big-number data.data.balance