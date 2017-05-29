iserror = (require \./iserror.js) 'strategist'

strategist = ([func, ...tail], value, cb) -->
    return cb null if not func?
    err, result <-! func value
    return cb err, result if not err?
    err, last-result <-! strategist tail, value
    return cb err if iserror err, "Last Strategy didn't work"
    cb err, last-result

module.exports = strategist