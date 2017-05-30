require! {
    \big.js
    \prelude-ls : \p
}

iserror = (require \../iserror.js) \calc_module

module.exports = (get-amount)->
    amounts = []
    zero =->
       big(0) 
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
        err, amount <-! get-amount item.0
        iserror err
        if amount?
          item.1 = amount
        next-index!
        calc-total!
        set-timeout collect, interval!
    start = ->
        state.paused = no
        collect!
    stop = ->
        state.paused = yes
    status = ->
        if state.paused then \paused else \running
    get-address = (address)->
        amounts |> p.find (.0 is address)
    add-address = (address)->
        return if get-address(address)?
        amounts.push [address, zero!]
    remove-address = (address)->
        item = get-address(address)
        return if not item?
        index = amounts.index-of(item)
        if index > -1
           amounts.splice index, 1
    sum = (first, second)->
        first.plus second
    calc-total = ->
        state.total = 
           amounts |> p.map (.1)
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
    
    