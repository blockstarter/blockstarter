expect = require \expect
main = require \../main/main.js
{ encrypt, decrypt } = main.encrypt-private-key
p = require \prelude-ls

describe \NewAddrHide , (...)->
  it \key_is_not_defined, (done)->
    @timeout 10000
    email = "testmail@gmail.com"
    new-addr = main.new-addr-hide
    for coin in [\eth, \btc, \ltc]
        err, result <-! new-addr coin, email
        expect(err).to-be "Key is not defined"
    done!
  it \need_at_least_2, (done)->
    @timeout 10000
    email = "testmail@gmail.com"
    new-addr = main.new-addr-hide
    key = "8e3dc782fc8375c43f59403a337db4ba"
    config = 
      repos: []
      key: "aasdfsadfasfdsafsf23Pp8j9232"
    err, encrypted-config <-! encrypt JSON.stringify(config), key
    expect(err).to-be null
    err <-! new-addr.setup encrypted-config
    expect(err).to-be null
    for coin in [\eth, \btc, \ltc]
        err, result <-! new-addr coin, email
        expect(err).to-be "You need at least 2 repos"
    done!
  it \process, (done)->
    @timeout 10000
    email = "testmail@gmail.com"
    new-addr = main.new-addr-hide
    key = "8e3dc782fc8375c43f59403a337db4ba"
    infos = []
    config = 
      repos: 
        * \blockstarter-235.firebase.com
        * \blockstarter-233.firebase.com
        * \blockstarter-400.firebase.com
      key: "aasdfsadfasfdsafsf23Pp8j9232"
    err, encrypted-config <-! encrypt JSON.stringify(config), key
    expect(err).to-be null
    err <-! new-addr.setup encrypted-config
    expect(err).to-be null
    coins = [\eth, \btc, \ltc]
    
    test-coins = ([coin, ...tail], cb)->
      return cb null if not coin?
      err, address <-! new-addr coin, email
      expect(err).to-be null
      expect(address).to-be-a \string
      expect(address.length > 10).to-be yes
      #key = config.key + coin + JSON.stringify(email)
      test-coins tail, cb
    test-coins coins, done
    