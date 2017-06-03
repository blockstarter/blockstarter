// Generated by LiveScript 1.5.0
(function(){
  var request, rateCache, iserror;
  request = require('request');
  rateCache = require('./rate-cache.js');
  iserror = require('../iserror.js')('https://min-api.cryptocompare.com');
  module.exports = curry$(function(currency, cb){
    return request("https://min-api.cryptocompare.com/data/price?fsym=" + currency + "&tsyms=USD", function(err, response, body){
      var usdRate;
      if (iserror(err, "Failed to get rate for " + currency + "/USD")) {
        return cb(err);
      }
      try {
        usdRate = JSON.parse(body).USD;
        rateCache.update(currency, usdRate);
        cb(null, usdRate);
      } catch (e$) {
        err = e$;
        cb(err);
      }
    });
  });
  function curry$(f, bound){
    var context,
    _curry = function(args) {
      return f.length > 1 ? function(){
        var params = args ? args.concat() : [];
        context = bound ? context || this : this;
        return params.push.apply(params, arguments) <
            f.length && arguments.length ?
          _curry.call(context, params) : f.apply(context, params);
      } : f;
    };
    return _curry();
  }
}).call(this);