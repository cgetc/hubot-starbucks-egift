# Description:
#   Utility commands surrounding Hubot uptime.

fs = require 'fs'
Starbucks = require 'starbucks-egift-client'

module.exports = (robot) ->
    starbucks = Starbucks.client
        site_url: 'https://gift.starbucks.co.jp/card/',
        remote_url: 'http://127.0.0.1:4444/wd/hub',
        capability: 'chrome'

    form = 
        mail_address: process.env.STARBUCKS_MAIL_ADDRESS,
        credit_number: process.env.STARBUCKS_CREDIT_NUMBER,
        credit_month: process.env.STARBUCKS_CREDIT_MONTH,
        credit_year: process.env.STARBUCKS_CREDIT_YEAR
    
    judge = {}
    fs.readdir 'judge', (err, files) ->
        throw err if err
        files.forEach (file) ->
            matches = file.match /(\w+)\.coffee$/
            if matches
                judge[matches[1]] = require "../judge/#{file}"

    messages = JSON.parse fs.readFileSync('resources/message.json', 'utf8')

    robot.router.post "/:judge/:room_name", (req, res) ->
        ret = judge[req.params.judge] req.body
        return res.end ret if ret isnt true

        room_name = req.params.room or process.env.HUBOT_DEFAULT_POST_ROOM

        starbucks.create_giftcard form, (url) ->
           	message = messages[Math.floor Math.random() * messages.length]
            robot.send {room: room_name}, message + "\n" + url
            res.end "send to ##{room_name}"
        , (e) ->
            console.log e
            res.end "error #{e.message}"

    robot.hear /judge/ , (msg) ->
        console.log judge