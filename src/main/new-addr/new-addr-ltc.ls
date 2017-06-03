require! {
    \coininfo
    \coinkey
}

gen = (type)->
    info =
        coininfo type
    private-key = coinkey.create-random info
    ck = new coinkey private-key.key
    private-key: ck.private-key.toString('hex')
    address: ck.public-address
    public: ck.public-hash.to-string \hex
    
module.exports = (type)->
    
    switch type 
       case \test 
         gen \LTC-TEST
       else
         gen \LTC

module.exports.verify = (address)->
    #pattern = \LajyQBeZaBA1NkZDeY8YT5RYYVRkXMvb2T
    #address.length is pattern.length
    yes