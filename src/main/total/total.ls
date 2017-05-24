p = require \prelude-ls
big-number = require \big.js
module.exports = (calc, rates)-->
   zero = ->
       big-number 0
   items = calc!
   coins = Object.keys items
   start-collect = ->
       coins |> p.each -> items[it].start!
   stop-collect = ->
       coins |> p.each -> items[it].stop!
   build-total = (item, name)->
       name: name
       total: item.total!
   calc-total = (names, callback)->
       [head, ...tail] = names
       return callback [] if not head?
       total = items[head].total!
       usd <-! rates[head]
       item =
           name: head
           amount: total
           amount-usd: big-number(usd).times total
           rate: usd
       rest <-! calc-total tail
       callback [item] ++ rest
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
       items <-! calc-total coins
       total-usd =
           items |> p.map (.amount-usd) 
                 |> p.foldl sum, zero!
       result =
         total-usd: total-usd.to-string!
         details: items |> p.map render-total
       done result
           
   { 
   start-collect
   stop-collect
   totals
   items 
   }