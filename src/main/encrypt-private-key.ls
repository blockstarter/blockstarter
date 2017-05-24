# TODO https://github.com/bitcoinjs/bip38
bip38 = require \bip38
wif = require \wif


export
  encrypt: (string, key)->
    decoded = wif.decode string
    return bip38.encrypt decoded.private-key, decoded.compressed, key
  decrypt: (string, key)->
    progress = (status)->
        console.log(status.percent)
    decrypted-key = bip38.decrypt string, key, progress
    wif.encode decrypted-key.privateKey, decrypted-key.compressed