require! {
    \ethereumjs-util : \eth-util
    \crypto
}



module.exports = (type)->
  priv-key-buff = crypto.random-bytes 32
  addr-buff = eth-util.private-to-address priv-key-buff
  pub-buff = eth-util.private-to-public priv-key-buff
  switch type 
    case \test
      null
    else 
      address: \0x + addr-buff.to-string \hex
      private-key: priv-key-buff.to-string \hex
      public: pub-buff.to-string \hex

module.exports.verify = (str)->
  pattern = \0xde0B295669a9FD93d5F28D9Ec85E40f4cb697BAe
  pattern.length is str.length and str.substr(0, 2) is "0x"
  
