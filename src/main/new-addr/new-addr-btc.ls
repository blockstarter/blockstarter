require! {
  \bitcoinjs-lib : \bitcoin
  \bitcoin-address
  \coinkey
}

module.exports = ->
  key-pair = bitcoin.ECPair.make-random!
  key = new coinkey.from-wif key-pair.toWIF!
  #console.log "test", key.public-address.to-string(\hex), key-pair.get-address!
  address: key-pair.get-address!
  private-key: key-pair.toWIF!
  public: key.public-hash.to-string \hex

module.exports.verify = (name)->
  bitcoin-address.validate name