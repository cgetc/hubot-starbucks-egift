# Description:
#   Utility commands surrounding Hubot uptime.

fs = require 'fs'
Starbucks = require 'starbucks-egift-client'
judge = require '../resources/judge'

module.exports = (robot) ->
    starbucks = Starbucks.client
        site_url: 'https://gift.starbucks.co.jp/card/',
        remote_url: 'http://127.0.0.1:4444/wd/hub/',
        capability: 'chrome'

    form = 
        mail_address: process.env.STARBUCKS_MAIL_ADDRESS,
        credit_number: process.env.STARBUCKS_CREDIT_NUMBER,
        credit_month: process.env.STARBUCKS_CREDIT_MONTH,
        credit_year: process.env.STARBUCKS_CREDIT_YEAR

    messages = JSON.parse fs.readFileSync('resources/message.json', 'utf8')

    robot.router.post "/hubot/starbucks/", (req, res) ->
        ret = judge JSON.parse req.body.payload
        if ret != true
            res.end ret
            return

        room_name = req.body.room or process.env.HUBOT_DEFAULT_POST_ROOM

        starbucks.create_giftcard form, (url) ->
           	message = messages[Math.floor Math.random() * messages.length]
            robot.send {room: room_name}, message + "\n" + url
            res.end "send to ##{room_name}"
        , (e) ->
            console.log e
            message = e.getMessage()
            res.end "error #{message}"