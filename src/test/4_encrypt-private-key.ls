expect = require \expect
main = require \../main/main.js

describe \Encrypt , (...)->
  it \basic, ->
    @timeout 10000
    t = main.encrypt-private-key
    message = "5KN7MzqK5wt2TP1fQCYyHBtDrXdJuXbUzm4A9rKAteGu3Qi5CVR"
    key = "TestingOneTwoThree"
    encrypted =
      t.encrypt message, key
    #decrypted =
    #  t.decrypt encrypted, key
    #expect(decrypted).to-be(message)
    