require! {
    \prelude-ls : \p
    \big.js
}

module.exports = (calc, rates)-->
   zero = ->
       big 0
   items = calc!
   coins = Object.keys items
   start = ->
       coins |> p.each -> items[it].start!
   stop = ->
       coins |> p.each -> items[it].stop!
   collect = { start, stop }
   calc-total = ([head, ...tail], cb)->
       return cb null, [] if not head?
       total = items[head].total!
       err, usd <-! rates[head]
       return cb err if err?
       item =
           name: head
           amount: total
           amount-usd: big(usd).times total
           rate: usd
       err, rest <-! calc-total tail
       return cb err if err?
       cb null, ([item] ++ rest)
   sum = (first, second)->
       first.plus second
   render-total = (total)->
       { 
       total.name
       amount: total.amount.to-string!
       amount-usd: total.amount-usd.to-string!
       total.rate
       }
   totals = (done)->
       err, items <-! calc-total coins
       return done err if err?
       total-usd =
           items |> p.map (.amount-usd)
                 |> p.foldl sum, zero!
       #console.log \total, total-usd.to-string!, items.0
       result =
         total-usd: total-usd.to-string!
         details: items |> p.map render-total
       done null, result
           
   { 
   collect
   totals
   items 
   }