require! { 
    expect 
    \../main/main.js
    \big.js
    \prelude-ls : \p
    \moment
}

all-coins = [\eth, \btc, \ltc]

run <-! describe \Basic

it \exists, ->
  for coin in all-coins
     provider = main.new-addr[coin]
     #expect(provider!.public).to-be-a("string", "Not string Public Key #{coin}")
     expect(provider!.address).to-be-a("string", "Not string Address #{coin}")
     expect(provider!.private-key).to-be-a("string", "Not string Private Key #{coin}")

it \unique, ->
  for coin in all-coins
     provider = main.new-addr[coin]
     #expect(provider!.public).to-not-be(provider!.public, "Not unique Public Key #{coin}")
     expect(provider!.address).to-not-be(provider!.address, "Not unique Private Key #{coin}")
     expect(provider!.private-key).to-not-be(provider!.private-key, "Not unique Private Key #{coin}")

it \valid, ->
  for coin in all-coins
    provider = main.new-addr[coin]
    { address, private-key } = provider!
    valid = provider.verify address
    expect valid .to-be yes, "Invalid #{coin} Address"
    message = "Test Message"
    signature =
      main.sign[coin].sign message, private-key
      
    expect(main.sign[coin].verify(message, address, signature)).to-be yes

it \balance, (done)!->
  @timeout 25000
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
  check-balance = (coin, cb)->
      acc = accs[coin]
      provider = main.balance[coin]
      err, balance <-! provider acc.address
      try
        expect(err).to-be null
        expect(balance).to-not-be(null, "Balance is null for #{coin}")
        expect(balance.eq(acc.balance)).to-be(true, "real balance #{balance.to-string!} is not expected #{acc.balance.to-string!} for #{coin}")
        cb null
      catch err
        cb err
  check-balances = (coins, cb)->
    return cb null if coins.length is 0
    err <-! check-balance coins.0
    expect err .to-be null
    tail =
      coins |> p.tail
    if tail.length is 0
       return cb null
    err <-! check-balances tail
    expect err .to-be null
    cb err
  err <-! check-balances all-coins
  expect err .to-be null
  done null