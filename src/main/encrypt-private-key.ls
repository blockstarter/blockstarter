crypto2 = require \crypto2
p = require \prelude-ls

export genpass = (cb)->
  err, password <-! crypto2.create-password
  cb password

algorithms =
  * [crypto2~encrypt, crypto2~decrypt]
  * [crypto2.encrypt~aes256cbc, crypto2.decrypt~aes256cbc]
  ...


encrypt-decrypt = (index, [head, ...tail], string, key, cb)-->
  return cb string if not head?
  err, current <-! head[index] string, key
  final <-! encrypt-decrypt index, tail, current, key
  cb final
  

export encrypt = encrypt-decrypt 0, algorithms

export decrypt = encrypt-decrypt 1, p.reverse(algorithms)