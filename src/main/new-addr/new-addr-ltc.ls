coininfo = require \coininfo
CoinKey = require \coinkey

gen = (type)->
    info =
        coininfo type
    private-key = CoinKey.createRandom(info)
    ck = new CoinKey private-key.key
    private-key: ck.private-key.toString('hex')
    address: ck.public-address 
    
module.exports = (type)->
    
    switch type 
       case \test 
         gen \LTC-TEST
       else
         gen \LTC

module.exports.verify = (address)->
    pattern = \LajyQBeZaBA1NkZDeY8YT5RYYVRkXMvb2T
    address.length is pattern.length