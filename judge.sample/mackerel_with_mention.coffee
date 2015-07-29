fs = require 'fs'
Slack = require('slack-node')
slack = new Slack process.env.HUBOT_SLACK_TOKEN
messages = JSON.parse fs.readFileSync('resources/message.json', 'utf8')

random = (arr) ->
    arr[Math.floor Math.random() * arr.length]

module.exports = (robot, req) ->
    data = req.body
    if !data.alert or data.alert.status != 'ok'
        return send: false, message: 'pass'
    hit = process.env.STARBUCKS_HIT or 1
    rand = Math.floor(Math.random() * hit)
    if rand != 0
        return send: false, message: "miss #{rand}"

    room = req.query.room or process.env.HUBOT_DEFAULT_POST_ROOM
    ret =
        send: true
        options:
            room: room
        message: random messages

    slack.api 'channels.list', (err, res) ->
        if err
            robot.logger.error err
            return
        if !res.ok
            robot.logger.error res.error
            return

        res.channels.forEach (channel) ->
            return true unless channel.name == room
            member = random channel.members
            ret.options.mention = "<@#{member}>"
            return false
    ret
