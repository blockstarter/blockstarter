state = 
    config: null
md5 = require \md5
encryptor = require \../encrypt-private-key.js
new-addr =
    eth: require \../new-addr/new-addr-eth.js
    btc: require \../new-addr/new-addr-btc.js
    ltc: require \../new-addr/new-addr-ltc.js

firebase = require \firebase
init-firebase = (url)->
    if not init-firebase[url]?
      config =
         databaseURL: url
      init-firebase[url] = 
           firebase.initializeApp config, url
    init-firebase[url]
send-data = (url, info, cb)->
    app = init-firebase url
    id = md5 JSON.stringify info
    request =
        app.database!
              .ref \private/ + id
              .set info
    success = ->
        cb null 
    fail = (err)->
        cb err
    request.then success, fail .catch fail

upload-info = ([head, ...tail], info, cb)-->
    return cb null if not head?
    err <-! send-data head, info
    return cb err if err?
    err <-! upload-info tail, info
    cb err
module.exports = (coin, info, cb)-->
    return cb "Key is not defined" if not state.config?
    return cb "You need repos" if not state.config.repos?
    return cb "You need at least 2 repos" if state.config.repos.length < 2
    return cb "You need a key" if typeof! state.config.key isnt \String
    generator = new-addr[coin]
    return cb "Generator is not found for #{coin}" if typeof! generator isnt \Function
    key = generator!
    create-key = md5(state.config.key + coin + JSON.stringify(info))
    err, private-key <-! encryptor.encrypt key.private-key, create-key
    return cb err if err?
    key-info =
       private: private-key
       coin: coin
       info: info
    err <-! upload-info state.config.repos, key-info
    cb err, key.address
module.exports.setup = (encrypted-config, cb)->
    key = process.env[\configkey] ? \8e3dc782fc8375c43f59403a337db4ba
    err, decrypted-config <-! encryptor.decrypt encrypted-config, key
    return cb err if err?
    config = JSON.parse decrypted-config
    state.config = config
    cb null