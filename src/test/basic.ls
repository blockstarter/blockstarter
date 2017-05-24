main = require \../main/main.js
big-number = require \big-number

expect = require \expect

describe 'Basic', !(_)->
  it \exists, !->
    for coin in [\eth, \btc, \ltc]
       provider = main.new-addr[coin]
       #expect(provider!.public).to-be-a("string", "Not string Public Key #{coin}")
       expect(provider!.address).to-be-a("string", "Not string Address #{coin}")
       expect(provider!.private-key).to-be-a("string", "Not string Private Key #{coin}")
  it \unique, !->
    for coin in [\eth, \btc, \ltc]
       provider = main.new-addr[coin]
       #expect(provider!.public).to-not-be(provider!.public, "Not unique Public Key #{coin}")
       expect(provider!.address).to-not-be(provider!.address, "Not unique Private Key #{coin}")
       expect(provider!.private-key).to-not-be(provider!.private-key, "Not unique Private Key #{coin}")
  it \valid, !->
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
    accs =
      eth: 
        address: "0xde0B295669a9FD93d5F28D9Ec85E40f4cb697BAe"
        balance: big-number "802672.276608465139479303"
      ltc: 
        address: "LajyQBeZaBA1NkZDeY8YT5RYYVRkXMvb2T"
        balance: big-number "7601.11229246"
      btc: 
        address: '16oZmpFVHpXVgyegWYXg4zNFhXVxYJemmY'
        balance: big-number "31.31659632"
    coins = [\eth, \btc, \ltc]
    check-balance = (coin, callback)->
        acc = accs[coin]
        provider = main.balance[coin]
        balance <-! provider acc.address
        expect(balance.equals(acc.balance)).to-be(true, "real balance #{balance.to-string!} is not expected #{acc.balance.to-string!} for #{coin}")
        callback balance
    check-balances = (coins, callback)->
      [head, ...tail] = coins
      <-! check-balance head
      if tail.length > 0
         check-balances tail, callback
      else
         callback!
      
        
    
    check-balances coins, done