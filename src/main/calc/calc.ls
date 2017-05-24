p = require \prelude-ls
big-number = require \big-number

module.exports = (get-amount)->
    amounts = []
    zero =->
       big-number(0) 
    state =
        paused: yes
        current: 0
        total: zero!
    total = ->
        state.total
    interval = ->
        | amounts.length > 100 => 1000
        | amounts.length < 10 => 5000
        | _ => 3000
    next-index = ->
        max-index = amounts.length - 1
        state.current =
           | state.current >= max-index => 0
           | _ => state.current + 1
    collect = ->
        return if amounts.length is 0
        return if state.paused
        item = amounts[state.current]
        item.1 =
          get-amount item
        next-index!
        set-timeout collect, interval!
    start = ->
        state.paused = no
        collect!
    stop = ->
        state.paused = yes
    status = ->
        if state.paused then \paused else \running
    add-address = (address)->
        state.amounts.push [address, 0]
    remove-address = (address)->
        item = 
            state.amounts |> p.filter (-> it.0 is address) |> p.head
        return if not item?
        index = state.amounts.index-of(item)
        if index > -1
           state.amounts.splice index, 1
    sum = (first, second)->
        first.plus second
    calc-total = ->
        state.total = 
           state.amounts |> p.map (.1)
                         |> p.filter (?)
                         |> p.foldl sum, zero!
    { 
    amounts
    start
    stop
    status
    add-address
    remove-address
    total 
    } 
    
    