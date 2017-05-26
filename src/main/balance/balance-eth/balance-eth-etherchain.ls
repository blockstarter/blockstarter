request = require \request
cheerio = require \cheerio
big-number = require \big.js
iserror = require \../../iserror.js
#unconfirmed
#http://ltc.blockr.io/api/v1/address/unconfirmed/LajyQBeZaBA1NkZDeY8YT5RYYVRkXMvb2T

module.exports = (key, callback)->
    err, response <-! request "https://etherchain.org/account/#{key}"
    
    return callback null if iserror err, "Balance eth #{key}"
    $ = cheerio.load response.body
    html = $('#account>.table tr>td').eq(1).html!
    return callback null if not html?
    tr = html.match("^[0-9\.]+").0
    callback big-number tr