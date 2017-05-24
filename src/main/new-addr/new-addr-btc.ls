bitcoin = require \bitcoinjs-lib
bitcoin-address = require \bitcoin-address
module.exports = ->
  key-pair = bitcoin.ECPair.make-random!
  address: key-pair.get-address!
  private-key: key-pair.toWIF!
  public: ""

module.exports.verify = (name)->
  bitcoin-address.validate name