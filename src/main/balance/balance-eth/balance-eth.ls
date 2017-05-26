strategist = require \../../strategist.js
strategies =
    * require \./balance-eth-etherscan.js
    * require \./balance-eth-etherchain.js
module.exports = strategist strategies
    