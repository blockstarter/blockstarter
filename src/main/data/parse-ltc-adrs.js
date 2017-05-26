// Examples:
// https://bitinfocharts.com/litecoin/block/1210199/8ba6adebe0b32c50ab4099a01fd6fe01581e4d8e3c3ea053ec5ec11cf5a207b6

var adrSet = new Set()
var adrs = []
$('table .ss3').next().each(function () {
  var address = $(this).find('a').attr('href')
  if (address) {
    address = address.replace('/litecoin/address/', '')
    var balance = $(this).next().text().replace(' LTC', '')
    var balNum = parseFloat(balance)
    if (!adrSet.has(address) && balNum >= 0.1) {
      adrSet.add(address)
      var adr = { address, balance, currency: 'LTC' }
      adrs.push(adr)
      console.log(adr)
    }
  }
})

console.log(JSON.stringify(
  adrs,
  null, 2));