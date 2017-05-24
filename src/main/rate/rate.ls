request = require \request
big-number = require \big.js

module.exports = (name, callback)-->
    err, response, body <-! request "\https://min-api.cryptocompare.com/data/price?fsym=#{name}&tsyms=USD"
    return callback null if err?
    try 
      data = JSON.parse body
      callback data.USD
    catch 
      callback null