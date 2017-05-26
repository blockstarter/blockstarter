# TODO https://github.com/bitcoinjs/bip38
bip38 = require \bip38
wif = require \wif


export encrypt = (string, key)->
  decoded = wif.decode string
  bip38.encrypt 128, decoded.private-key, decoded.compressed, key
export decrypt = (string, key)->
  progress = (status)->
      #console.log("decoding: #{status.percent}%")
  decrypted-key = bip38.decrypt string, key, progress
  wif.encode decrypted-key.privateKey, decrypted-key.compressed