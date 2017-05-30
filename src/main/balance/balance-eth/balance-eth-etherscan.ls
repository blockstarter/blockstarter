require! {
    \request
    \cheerio
    \big.js
}
iserror = (require \../../iserror.js) 'https://etherscan.io'

# unconfirmed
# http://ltc.blockr.io/api/v1/address/unconfirmed/LajyQBeZaBA1NkZDeY8YT5RYYVRkXMvb2T

module.exports = (key, callback)->
    err, response <-! request "https://etherscan.io/address/#{key}"
    return callback "Not Found" if iserror err, "Failed to get balance of ETH address #{key}"
    $ = cheerio.load response.body
    html = $('#ContentPlaceHolder1_divSummary .col-md-6 table td').eq(1).html!
    return callback "Not Found" if not html?
    tr = html.replace(/[^0-9.]/g,"")
    callback null, big(tr)