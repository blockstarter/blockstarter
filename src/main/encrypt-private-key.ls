require! {
  crypto2
  \prelude-ls : \p
}

export genpass = (cb)->
  err, password <-! crypto2.create-password
  cb err, password

algorithms =
  * [crypto2~encrypt, crypto2~decrypt]
  * [crypto2.encrypt~aes256cbc, crypto2.decrypt~aes256cbc]
  ...


encrypt-decrypt = (index, [head, ...tail], string, key, cb)-->
  return cb null, string if not head?
  err, current <-! head[index] string, key
  return err if err?
  err, final <-! encrypt-decrypt index, tail, current, key
  cb err, final
  

export encrypt = encrypt-decrypt 0, algorithms

export decrypt = encrypt-decrypt 1, p.reverse(algorithms)