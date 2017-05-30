# Docs: https://blockchain.info/api/api_websocket
require! {
    fs
    \prelude-ls : \p
}
iserror = (require \../iserror.js) \wss://ws.blockchain.info

# I don't know where to use API key. Cannot find in API docs.
apiKey = \936e3ef9-7781-47ec-86d2-260804c1920f

btcAdrs = require \../data/btc-adrs.json

WebSocket = require \ws
ws = new WebSocket \wss://ws.blockchain.info/inv

send = JSON.stringify >> ws~send

store = (file, data)->
  fs.append-file "./logs/#{file}.log", data + \\n, ->

log = (data)->
  console.log data
  data

cmd =
  subsToAdr: (-> op: \addr_sub", addr: it) >> send
  ping: (-> op: \ping) >> send

max = 100000
addresses =
    btcAdrs |> p.drop 0 
            |> p.take max

subsToKnownAdrs = ->
    console.log "Subscribe to #{addresses.length} BTC addresses"
    addresses |> p.map (.address)
              |> p.each cmd.subsToAdr

map-filter = (func, list)-->
  list |> p.map func 
       |> p.filter (?)

isSame = (input, stored)->
  console.log input
  no

locate = (input, stored)-->
    return null if not isSame input, stored
    {input, stored}
    
updateBalance = ({input, stored})->
     
checkBalances = (input)->
    addresses |> map-filter locate input
              |> p.each updateBalance

setup-ping = ->
  return if setup-ping.already
  setup-ping.already = yes
  set-interval cmd.ping, 29000
             
init = ->
  console.log '[ws.blockchain.info] connected to server'
  setup-ping!
  subsToKnownAdrs!

received = (data) ->
    json = JSON.parse data
    switch json.op
        case \pong
            store \ping, data
            console.log 'pong ' + new Date!
        else
            console.log '[ws.blockchain.info] received message: ' + data
            store \changes, data
            checkBalances data
        
exit = ->
    console.log '[ws.blockchain.info] closing connection'

ws
 .on \open , init
 .on \message , received
 .on \close , exit
    
