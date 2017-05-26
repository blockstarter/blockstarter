strategies =
    * require \./balance-eth-etherscan.js
    * require \./balance-eth-etherchain.js
    
get-balance = (strategies, key, callback)-->
    [head, ...tail] = strategies
    return callback null if not head?
    result <-! head key
    return callback result if result isnt null
    next-result <-! get-balance tail, key
    callback next-result
    
module.exports = get-balance strategies
    