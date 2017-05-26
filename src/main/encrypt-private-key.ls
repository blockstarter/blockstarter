crypto2 = require \crypto2

export genpass = (cb)->
  err, password <-! crypto2.create-password
  cb password

export encrypt = (string, key, cb)->
  err, encrypted <-! crypto2.encrypt string, key
  cb encrypted
  
export decrypt = (string, key, cb)->
  err, decrypted <-! crypto2.decrypt string, key
  cb decrypted