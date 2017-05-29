rates =
    btc: 2470
    ltc: 28.87
    eth: 187.96 

module.exports = (currency, cb) -->
    return cb "Currency #{currency} Not Found" if not rates[currency]?
    cb null, rates[currency]

module.exports.update = (currency, new-rate) -> 
    rates[currency] = new-rate

