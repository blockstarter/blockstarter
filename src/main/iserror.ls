SlackWebhook = require \slack-webhook
slack = new SlackWebhook do
    * 'https://hooks.slack.com/services/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'
    * defaults:
        username: 'Bot'
        channel: '#bot'
        icon_emoji: ':robot_face:'

module.exports = (err, more-info)->
    if err?
      slack.send "Error: #{err.message ? err} #{more-info ? ''}"
    err?