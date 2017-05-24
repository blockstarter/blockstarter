request = require \request
cheerio = require \cheerio
big-number = require \big.js

#unconfirmed
#http://ltc.blockr.io/api/v1/address/unconfirmed/LajyQBeZaBA1NkZDeY8YT5RYYVRkXMvb2T

module.exports = (key, callback)->
    err, response <-! request "https://etherscan.io/address/#{key}"
    return callback null if err?
    
    $ = cheerio.load response.body
    tr = $('#ContentPlaceHolder1_divSummary .col-md-6 table td').eq(1).html!.replace(/[^0-9.]/g,"")
    callback big-number tr