require! {
  \bitcoinjs-lib : \bitcoin
  \bitcoin-address
}


module.exports = ->
  key-pair = bitcoin.ECPair.make-random!
  address: key-pair.get-address!
  private-key: key-pair.toWIF!
  public: ""

module.exports.verify = (name)->
  bitcoin-address.validate name