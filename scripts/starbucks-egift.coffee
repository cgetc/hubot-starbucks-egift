fs = require 'fs'
Starbucks = require('starbucks-egift-client').client
    site_url: 'https://gift.starbucks.co.jp/card/',
    remote_url: 'http://127.0.0.1:4444/wd/hub/',
    capability: 'chrome'

form = 
    mail_address: process.env.STARBUCKS_MAIL_ADDRESS,
    credit_number: process.env.STARBUCKS_CREDIT_NUMBER,
    credit_month: process.env.STARBUCKS_CREDIT_MONTH,
    credit_year: process.env.STARBUCKS_CREDIT_YEAR

hit = process.env.STARBUCKS_HIT

messages = JSON.parse fs.readFileSync('message.json', 'utf8')

module.exports = (robot) ->
    robot.router.post '/hubot/starbucks/', (req, res) ->

        if Math.floor(Math.random() * hit) != 0
            res.end "miss"
            return

        room_name = req.body.room
        room_name = process.env.HUBOT_DEFAULT_POST_ROOM unless room_name

     	Starbucks.create_giftcard form, (url) ->
           	message = robot.random messages + "\n" + url
            robot.send {room: room_name}, message
            res.end "send #{room_name}"
        , (e) ->
            console.log e