#https://github.com/bitcoinjs/bitcoinjs-lib/blob/d853806/test/integration/multisig.js#L9
#https://github.com/bitpay/bitcore-lib/blob/master/docs/examples.md#create-a-2-of-3-multisig-p2sh-address

require! {
  \../new-addr-btc/new-addr-btc.js
}

module.exports = (common-public-key)->
    #console.log \run
    key = new-addr-btc!
    pub-keys =
      * common-public-key
      * key.public
    pub-keys-buffer =
       pub-keys.map -> new Buffer it, \hex
    redeem-script = bitcoin.script.multisig.output.encode 2, pub-keys-buffer
    script-pub-key = bitcoin.script.script-hash.output.encode bitcoin.crypto.hash160 redeem-script
    address = bitcoin.address.from-output-script script-pub-key
    {
        key.private-key
        key.public
        address
    }