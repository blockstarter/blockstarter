request = require \request
big-number = require \big-number

#unconfirmed
#http://ltc.blockr.io/api/v1/address/unconfirmed/LajyQBeZaBA1NkZDeY8YT5RYYVRkXMvb2T

module.exports = (key, callback)->
    err, response, body <-! request "http://ltc.blockr.io/api/v1/address/info/#{key}"
    return callback null if err?
    try 
      data = JSON.parse body
      callback big-number data.data.balance
    catch 
      callback null