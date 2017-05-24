// Generated by LiveScript 1.5.0
(function(){
  var coininfo, CoinKey, gen;
  coininfo = require('coininfo');
  CoinKey = require('coinkey');
  gen = function(type){
    var info, privateKey, ck;
    info = coininfo(type);
    privateKey = CoinKey.createRandom(info);
    ck = new CoinKey(privateKey.key);
    return {
      privateKey: ck.privateKey.toString('hex'),
      address: ck.publicAddress
    };
  };
  module.exports = function(type){
    switch (type) {
    case 'test':
      return gen('LTC-TEST');
    default:
      return gen('LTC');
    }
  };
  module.exports.verify = function(address){
    var pattern;
    pattern = 'LajyQBeZaBA1NkZDeY8YT5RYYVRkXMvb2T';
    return address.length === pattern.length;
  };
}).call(this);
