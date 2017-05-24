main = require \../main/main.js
big-number = require \big.js
p = require \prelude-ls

expect = require \expect

describe 'Basic', (...)->
  it \exists, ->
    for coin in [\eth, \btc, \ltc]
       provider = main.new-addr[coin]
       #expect(provider!.public).to-be-a("string", "Not string Public Key #{coin}")
       expect(provider!.address).to-be-a("string", "Not string Address #{coin}")
       expect(provider!.private-key).to-be-a("string", "Not string Private Key #{coin}")
  it \unique, ->
    for coin in [\eth, \btc, \ltc]
       provider = main.new-addr[coin]
       #expect(provider!.public).to-not-be(provider!.public, "Not unique Public Key #{coin}")
       expect(provider!.address).to-not-be(provider!.address, "Not unique Private Key #{coin}")
       expect(provider!.private-key).to-not-be(provider!.private-key, "Not unique Private Key #{coin}")
  it \valid, ->
    for coin in [\eth, \btc, \ltc]
      provider = main.new-addr[coin]
      { address, private-key } = provider!
      valid = provider.verify address
      expect valid .to-be yes, "Invalid Ethereum Address #{coin}"
      message = "Test Message"
      signature =
        main.sign[coin].sign message, private-key
        
      expect(main.sign[coin].verify(message, address, signature)).to-be yes
  it \balance, (done)!->
    @timeout 15000
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
    check-balance = (coin, callback)->
        acc = accs[coin]
        provider = main.balance[coin]
        balance <-! provider acc.address
        try
          expect(balance).to-not-be(null, "Balance is null for #{coin}")
          expect(balance.eq(acc.balance)).to-be(true, "real balance #{balance.to-string!} is not expected #{acc.balance.to-string!} for #{coin}")
        catch err
           console.log err
        callback!
    check-balances = (coins, callback)->
      return callback! if coins.length is 0
      <-! check-balance coins.0
      tail =
        coins |> p.tail
      if tail.length is 0
         return callback!
      <-! check-balances tail
      callback!
    <-! check-balances [\eth, \btc, \ltc]
    console.log \done
    done!
  it \rates, (done)->
    @timeout 5000
    coins = [\eth, \btc, \ltc]
    check-rate = (coin, callback)->
        provider = main.rate[coin]
        rate <-! provider!
        expect(rate).to-be-a(\number)
        callback rate
    check-rates = (coins, callback)->
      [head, ...tail] = coins
      <-! check-rate head
      return callback! if tail.length is 0
      check-rates tail, callback
    check-rates coins, done