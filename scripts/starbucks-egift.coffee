# Description:
#   Utility commands surrounding Hubot uptime.

fs = require 'fs'
Starbucks = require 'starbucks-egift-client'

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

    hit = process.env.STARBUCKS_HIT

    messages = JSON.parse fs.readFileSync('resources/message.json', 'utf8')

    robot.router.post "/hubot/starbucks/", (req, res) ->
        data = JSON.parse req.body.payload
        if data.alert.status != 'ok'
            res.end "pass"
            return

        rand = Math.floor(Math.random() * hit)
        if rand != 0
            res.end "miss #{rand}"
            return

        room_name = req.body.room
        room_name = process.env.HUBOT_DEFAULT_POST_ROOM unless room_name

        starbucks.create_giftcard form, (url) ->
           	message = robot.random messages + "\n" + url
            robot.send {room: room_name}, message
            res.end "send #{room_name}"
        , (e) ->
            console.log e
            message = e.getMessage()
            res.end "error #{message}"