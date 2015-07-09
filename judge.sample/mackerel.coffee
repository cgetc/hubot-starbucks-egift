fs = require 'fs'
messages = JSON.parse fs.readFileSync('resources/message.json', 'utf8')
module.exports = (robot, req) ->
    data = req.body
    if !data.alert or data.alert.status != 'ok'
        return send: false, message: 'pass'
    hit = process.env.STARBUCKS_HIT or 1
    rand = Math.floor(Math.random() * hit)
    if rand != 0
        return send: false, message: "miss #{rand}"

    send: true
    options:
        room: req.query.room or process.env.HUBOT_DEFAULT_POST_ROOM
    message: messages[Math.floor Math.random() * messages.length]
