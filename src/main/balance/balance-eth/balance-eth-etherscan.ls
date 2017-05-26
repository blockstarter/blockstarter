request = require \request
cheerio = require \cheerio
big-number = require \big.js
iserror = require \../../iserror.js
#unconfirmed
#http://ltc.blockr.io/api/v1/address/unconfirmed/LajyQBeZaBA1NkZDeY8YT5RYYVRkXMvb2T

module.exports = (key, callback)->
    err, response <-! request "https://etherscan.io/address/#{key}"
    
    return callback null if iserror err, "Balance eth #{key}"
    
    $ = cheerio.load response.body
    html = $('#ContentPlaceHolder1_divSummary .col-md-6 table td').eq(1).html!
    return callback null if not html?
    tr = html.replace(/[^0-9.]/g,"")
    callback big-number tr