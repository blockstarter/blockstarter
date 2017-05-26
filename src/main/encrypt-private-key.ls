crypto2 = require \crypto2

export genpass = (cb)->
  err, password <-! crypto2.create-password
  cb password

export encrypt = (string, key, cb)->
  err, encrypted <-! crypto2.encrypt string, key
  err, encrypted2 <-! crypto2.encrypt.aes256cbc encrypted, key
  cb encrypted2
  
export decrypt = (string, key, cb)->
  err, decrypted2 <-! crypto2.encrypt.aes256cbc string, key
  err, decrypted <-! crypto2.decrypt decrypted2, key
  cb decrypted