request = require \request
cheerio = require \cheerio
big-number = require \big-number

#unconfirmed
#http://ltc.blockr.io/api/v1/address/unconfirmed/LajyQBeZaBA1NkZDeY8YT5RYYVRkXMvb2T

module.exports = (key, callback)->
    err, response <-! request "https://blockchain.info/address/#{key}"
    return callback null if err?
    $ = cheerio.load response.body
    try
      tr = $('#final_balance span').html!.replace(/[^0-9.]/g,"")
    catch err
      callback null
    callback big-number tr
    
