// Examples:
// https://etherscan.io/txs?block=3762639
// https://etherscan.io/txs?block=3762620

var adrSet = new Set()
var adrs = []
$('.table-hover tr').slice(1).each(function () {
  var address = $(this).find('td:eq(5) a').attr('href')
  var isContract = $(this).find('td:eq(5) i').size() > 0;
  if (!isContract && address) {
    address = address.replace('/address/', '')
    var balance = $(this).find('td:eq(6)').text().replace(' Ether', '')
    var balNum = parseFloat(balance)
    if (!adrSet.has(address) && balNum >= 0.1) {
      adrSet.add(address)
      var adr = { address, balance, currency: 'ETH' }
      adrs.push(adr)
      console.log(adr)
    }
  }
})

console.log(JSON.stringify(
  adrs,
  null, 2));