require! {
    \request
    \cheerio
    \big.js
}

iserror = (require \../iserror.js) \https://blockchain.info

#unconfirmed
#http://ltc.blockr.io/api/v1/address/unconfirmed/LajyQBeZaBA1NkZDeY8YT5RYYVRkXMvb2T

module.exports = (key, callback)->
    err, response <-! request "https://blockchain.info/address/#{key}"
    return callback null if iserror err, "Failed to get balance of BTC address #{key}"
    $ = cheerio.load response.body
    html = $ '#final_balance span' .html!
    return callback null if not html?
    tr = $('#final_balance span').html!.replace /[^0-9.]/g, ""
    callback err, big(tr)