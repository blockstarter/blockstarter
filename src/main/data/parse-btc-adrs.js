// Examples:
// https://bitinfocharts.com/bitcoin/block/467299/0000000000000000011fc4f5e53bcad3bafa87922bcf26777e787b5b9fc61c43
// https://bitinfocharts.com/bitcoin/block/467971/000000000000000000c5a796854ec79712c0544e3922a466354f08b6a279b9f5

var adrSet = new Set()
var adrs = []
$('table .ss3').next().each(function () {
  var address = $(this).find('a').attr('href')
  if (address) {
    address = address.replace('/bitcoin/address/', '')
    var balance = $(this).next().text().replace(' BTC', '')
    var balNum = parseFloat(balance)
    if (!adrSet.has(address) && balNum >= 0.1) {
      adrSet.add(address)
      var adr = { address, balance, currency: 'BTC' }
      adrs.push(adr)
      console.log(adr)
    }
  }
})

console.log(JSON.stringify(
  adrs,
  null, 2));