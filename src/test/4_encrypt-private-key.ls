require! { 
    expect 
    \../main/main.js
}

run <-! describe \Encrypt
it \basic, (done)->
  @timeout 10000
  t = main.encrypt-private-key
  message = "5KN7MzqK5wt2TP1fQCYyHBtDrXdJuXbUzm4A9rKAteGu3Qi5CVR"
  err, key <-! t.genpass!
  expect err .to-be null
  err, encrypted <-! t.encrypt message, key
  expect err .to-be null
  err, decrypted <-! t.decrypt encrypted, key
  expect err .to-be null
  expect decrypted .to-be message
  done!
    