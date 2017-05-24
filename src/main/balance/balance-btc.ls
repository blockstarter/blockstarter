request = require \request
cheerio = require \cheerio
big-number = require \big.js

#unconfirmed
#http://ltc.blockr.io/api/v1/address/unconfirmed/LajyQBeZaBA1NkZDeY8YT5RYYVRkXMvb2T

module.exports = (key, callback)-->
    err, response <-! request "https://blockchain.info/address/#{key}"
    return callback null if err?
    $ = cheerio.load response.body
    try
      tr = $('#final_balance span').html!.replace(/[^0-9.]/g,"")
      callback big-number tr
    catch err
      callback null
    
    
