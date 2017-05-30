require! { 
    expect 
    \../main/main.js
    \big.js
}

run <-! describe \Totals
it \empty, (done)->
    @timeout 10000
    total =
       main.total main.rate
    err, result <-! total.totals
    expect err .to-be null
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
        callback null, rate
    total =
       main.total { btc: get-rate, ltc: get-rate, eth: get-rate }
    err, result <-! total.totals
    try 
        expect err .to-be null
        expect(result.total-usd).to-be('0')
        expect(result.details.length).to-be(3)
    catch err
        console.log err
    for detail in result.details
       expect(detail.amount).to-be('0')
       expect(detail.amount-usd).to-be('0')
       expect(detail.rate).to-be(rate)
    done null
it \add-address, (done)->
    @timeout 8000
    rate = 2
    get-rate = (callback)->
        callback null, rate
    accs =
      eth: 
        address: "0xde0B295669a9FD93d5F28D9Ec85E40f4cb697BAe"
        balance: big "802672.276608465139479303"
      ltc: 
        address: "34Ae29qWAhGGTw3cSNkPygiwsgKbbCatou"
        balance: big "402474.2484"
      btc: 
        address: '1HQ3Go3ggs8pFnXuHVHRytPCq5fGG8Hbhx'
        balance: big "69370.10701994"
    total =
       main.total { btc: get-rate, ltc: get-rate, eth: get-rate }
    state =
      expect-total: big 0
    for key in Object.keys(accs)
       total.items[key].add-address accs[key].address
    total.collect.start!
    <-! set-timeout _, 3000
    total.collect.stop!
    err, result <-! total.totals
    expect(err).to-be(null)
    expect(result.details.length).to-be(3)
    for detail in result.details
       acc = accs[detail.name]
       expect-total = acc.balance.times(big rate)
       state.expect-total =
            state.expect-total.plus expect-total
       expect(detail.amount).to-be(acc.balance.to-string!, "Total Amount is wrong for #{detail.name} expected #{acc.balance.to-string!} got #{detail.amount}")
       expect(detail.amount-usd).to-be(expect-total.to-string!, "Total Amount USD is wrong for #{detail.name} expected #{detail.amount-usd.to-string!} got #{expect-total.to-string!}")
       expect(detail.rate).to-be(rate, "Rate is wrong for #{detail.name}")
    expect(result.total-usd.to-string!).to-be(state.expect-total.to-string!, "Total Amount USD is wrong got #{result.total-usd.to-string!} expected #{state.expect-total.to-string!}")
    done null