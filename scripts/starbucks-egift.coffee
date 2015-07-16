# Description:
#   Utility commands surrounding Hubot uptime.

fs = require 'fs'
Starbucks = require 'starbucks-egift-client'

module.exports = (robot) ->
    starbucks = Starbucks.client
        log_dir: process.env.LOG_DIR,
        payment:
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
                judge[matches[1]] = require "../../../judge/#{file}"

    robot.router.post "/:judge", (req, res) ->
        ret = judge[req.params.judge] robot, req
        if ret.send isnt true
            robot.logger.info ret.message
            return res.end ret.message

        robot.logger.info "send to #{ret.options.room}"
        res.end "send to #{ret.options.room}"
        starbucks.create_giftcard ret.message, (url) ->
            message = ''
            if ret.options.mention
                message = ret.options.mention + ':'
                delete ret.options.mention
                message += ret.message + '\n' + url
            robot.send ret.options, message
        , (e) ->
            robot.logger.error e

    robot.respond /judge/ , (msg) ->
        robot.logger.info judge.toString()
