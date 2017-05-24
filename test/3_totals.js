// Generated by LiveScript 1.5.0
(function(){
  var main, bigNumber, expect;
  main = require('../main/main.js');
  bigNumber = require('big.js');
  expect = require('expect');
  describe('Totals', function(){
    it('empty', function(done){
      var total;
      this.timeout(10000);
      total = main.total(main.rate);
      return total.totals(function(result){
        var i$, ref$, len$, detail;
        expect(result.totalUsd).toBe('0');
        expect(result.details.length).toBe(3);
        for (i$ = 0, len$ = (ref$ = result.details).length; i$ < len$; ++i$) {
          detail = ref$[i$];
          expect(detail.amount).toBe('0');
          expect(detail.amountUsd).toBe('0');
          expect(detail.rate).toBeGreaterThan(0);
        }
        done();
      });
    });
    it('static-rate', function(done){
      var rate, getRate, total;
      rate = 1;
      getRate = function(callback){
        return callback(rate);
      };
      total = main.total({
        btc: getRate,
        ltc: getRate,
        eth: getRate
      });
      return total.totals(function(result){
        var i$, ref$, len$, detail;
        expect(result.totalUsd).toBe('0');
        expect(result.details.length).toBe(3);
        for (i$ = 0, len$ = (ref$ = result.details).length; i$ < len$; ++i$) {
          detail = ref$[i$];
          expect(detail.amount).toBe('0');
          expect(detail.amountUsd).toBe('0');
          expect(detail.rate).toBe(rate);
        }
        done();
      });
    });
    return it('add-address', function(done){
      var rate, getRate, accs, total, state, i$, ref$, len$, key;
      this.timeout(8000);
      rate = 2;
      getRate = function(callback){
        return callback(rate);
      };
      accs = {
        eth: {
          address: "0xde0B295669a9FD93d5F28D9Ec85E40f4cb697BAe",
          balance: bigNumber("802672.276608465139479303")
        },
        ltc: {
          address: "34Ae29qWAhGGTw3cSNkPygiwsgKbbCatou",
          balance: bigNumber("402474.2484")
        },
        btc: {
          address: '1HQ3Go3ggs8pFnXuHVHRytPCq5fGG8Hbhx',
          balance: bigNumber("69370.10701994")
        }
      };
      total = main.total({
        btc: getRate,
        ltc: getRate,
        eth: getRate
      });
      state = {
        expectTotal: bigNumber(0)
      };
      for (i$ = 0, len$ = (ref$ = Object.keys(accs)).length; i$ < len$; ++i$) {
        key = ref$[i$];
        total.items[key].addAddress(accs[key].address);
      }
      total.collect.start();
      return setTimeout(function(){
        total.collect.stop();
        total.totals(function(result){
          var i$, ref$, len$, detail, acc, expectTotal;
          expect(result.details.length).toBe(3);
          for (i$ = 0, len$ = (ref$ = result.details).length; i$ < len$; ++i$) {
            detail = ref$[i$];
            acc = accs[detail.name];
            expectTotal = acc.balance.times(bigNumber(rate));
            state.expectTotal = state.expectTotal.plus(expectTotal);
            console.log("--", state.expectTotal.toString(), expectTotal.toString());
            expect(detail.amount).toBe(acc.balance.toString(), "Total Amount is wrong for " + detail.name + " expected " + acc.balance.toString() + " got " + detail.amount);
            expect(detail.amountUsd).toBe(expectTotal.toString(), "Total Amount USD is wrong for " + detail.name + " expected " + detail.amountUsd.toString() + " got " + expectTotal.toString());
            expect(detail.rate).toBe(rate, "Rate is wrong for " + detail.name);
          }
          expect(result.totalUsd.toString()).toBe(state.expectTotal.toString(), "Total Amount USD is wrong got " + result.totalUsd.toString() + " expected " + state.expectTotal.toString());
          done();
        });
      }, 3000);
    });
  });
}).call(this);