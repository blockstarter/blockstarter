require! { 
    \slack-webhook
}


slack = new slack-webhook do
    * 'https://hooks.slack.com/services/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'
    * defaults:
        username: 'Bot'
        channel: '#bot'
        icon_emoji: ':robot_face:'

module.exports = (service-name, err, details) -->
    if err?
        err-details = "; #details" if details?
        slack.send "[#{service-name}] Error: #{err.message ? err}#{err-details}"
    err?