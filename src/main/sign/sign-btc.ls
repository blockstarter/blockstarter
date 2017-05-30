require! {
    \bitcore-lib : \bitcore
    \bitcore-message
}

module.exports =
    sign: (message, private-key)->
        key = bitcore.PrivateKey private-key
        bitcore-message(message).sign(key)
    verify: (message, address, signature)->
        bitcore-message(message).verify(address, signature)