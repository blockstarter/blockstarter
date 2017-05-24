main = require \../main/main.js
big-number = require \big-number
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
        get-rate = (callback)->
            callback 1
        total =
           main.total { btc: get-rate, ltc: get-rate, eth: get-rate }
        result <-! total.totals
        expect(result.total-usd).to-be('0')
        expect(result.details.length).to-be(3)
        for detail in result.details
           expect(detail.amount).to-be('0')
           expect(detail.amount-usd).to-be('0')
           expect(detail.rate).to-be(1)
        done!