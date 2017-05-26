go = (strategies, key, callback)-->
    [head, ...tail] = strategies
    return callback null if not head?
    result <-! head key
    return callback result if result isnt null
    next-result <-! go tail, key
    callback next-result

module.exports = go