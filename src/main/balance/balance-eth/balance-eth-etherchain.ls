require! {
    \request
    \cheerio
    \big.js
}

iserror = (require \../../iserror.js) 'https://etherchain.org'

# unconfirmed
# http://ltc.blockr.io/api/v1/address/unconfirmed/LajyQBeZaBA1NkZDeY8YT5RYYVRkXMvb2T

module.exports = (key, callback)->
    err, response <-! request "https://etherchain.org/account/#{key}"
    
    return callback err if iserror err, "Failed to get balance of ETH address #{key}"
    $ = cheerio.load response.body
    html = $('#account>.table tr>td').eq(1).html!
    return callback "Value Not Found" if not html?
    tr = html.match("^[0-9\.]+").0
    callback null, big(tr)