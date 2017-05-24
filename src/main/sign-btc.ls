bitcore = require \bitcore-lib
Message = require \bitcore-message

module.exports =
    sign: (message, private-key)->
        key = bitcore.PrivateKey private-key
        Message(message).sign(key)
    verify: (message, address, signature)->
        Message(message).verify(address, signature)