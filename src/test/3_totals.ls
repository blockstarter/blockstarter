main = require \../main/main.js
big-number = require \big.js
expect = require \expect

describe \Totals, (...)->
    it \empty, (done)->
        @timeout 5000
        total =
           main.total main.rate
        result <-! total.totals
        expect(result.total-usd).to-be('0')
        expect(result.details.length).to-be(3)
        for detail in result.details
           expect(detail.amount).to-be('0')
           expect(detail.amount-usd).to-be('0')
           expect(detail.rate).to-be-greater-than(0)
        done!
    it \static-rate, (done)->
        rate = 1
        get-rate = (callback)->
            callback rate
        total =
           main.total { btc: get-rate, ltc: get-rate, eth: get-rate }
        result <-! total.totals
        expect(result.total-usd).to-be('0')
        expect(result.details.length).to-be(3)
        for detail in result.details
           expect(detail.amount).to-be('0')
           expect(detail.amount-usd).to-be('0')
           expect(detail.rate).to-be(rate)
        done!
    it \add-address, (done)->
        @timeout 15000
        rate = 2
        get-rate = (callback)->
            callback rate
        accs =
          eth: 
            address: "0xde0B295669a9FD93d5F28D9Ec85E40f4cb697BAe"
            balance: big-number "802672.276608465139479303"
          ltc: 
            address: "LajyQBeZaBA1NkZDeY8YT5RYYVRkXMvb2T"
            balance: big-number "11238.41463408"
          btc: 
            address: '16oZmpFVHpXVgyegWYXg4zNFhXVxYJemmY'
            balance: big-number "31.6455421"
        total =
           main.total { btc: get-rate, ltc: get-rate, eth: get-rate }
        state =
          expect-total: big-number 0
        for key in Object.keys(accs)
           total.items[key].add-address accs[key].address
        total.collect.start!
        <-! set-timeout _, 4000
        total.collect.stop!
        result <-! total.totals
        expect(result.details.length).to-be(3)
        for detail in result.details
           acc = accs[detail.name]
           expect-total = acc.balance.times(big-number rate)
           state.expect-total.plus expect-total
           expect(detail.amount).to-be(acc.balance.to-string!, "Total Amount is wrong for #{detail.name} expected #{acc.balance.to-string!} got #{detail.amount}")
           expect(detail.amount-usd).to-be(expect-total.to-string!, "Total Amount USD is wrong for #{detail.name} expected #{detail.amount-usd.to-string!} got #{expect-total.to-string!}")
           expect(detail.rate).to-be(rate, "Rate is wrong for #{detail.name}")
        expect(result.total-usd).to-be(state.expect-total.to-string!, "Total Amount USD is wrong}")
        done!