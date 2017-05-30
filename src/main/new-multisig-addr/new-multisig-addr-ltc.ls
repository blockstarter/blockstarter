require! {
  \../new-addr-btc/new-addr-ltc.js
}

module.exports = (common-public-key)->
    console.log \run
    key = new-addr-ltc!
    litecoin = bitcoin.networks.litecoin
    pub-keys =
      * common-public-key
      * key.public
    pub-keys-buffer =
       pub-keys.map -> new Buffer it, \hex
    redeem-script = litecoin.script.multisig.output.encode 2, pub-keys-buffer
    script-pub-key = litecoin.script.script-hash.output.encode litecoin.crypto.hash160 redeem-script
    address = litecoin.address.from-output-script script-pub-key
    {
        key.private-key
        key.public
        address
    }

    