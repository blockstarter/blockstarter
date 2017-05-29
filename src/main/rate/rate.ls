strategist = require \../strategist.js
strategies =
    * require \./rate-cryptocompare.js
    * require \./rate-cache.js
module.exports = strategist strategies
    