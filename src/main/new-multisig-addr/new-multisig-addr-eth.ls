require! {
    \bitcoinjs-lib
}
module.exports = (number, pub-keys)->
  redeem-script = bitcoin.scripts.multisig-output number, pub-keys
  script-pub-key = bitcoin.scripts.script-hash-output redeem-script.get-hash!
  bitcoin.Address.from-output-script(script-pub-key).to-string!