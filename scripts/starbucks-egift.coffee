Starbucks = require 'starbucks-egift-client'

module.exports = (robot)->
	robot.router.post '/hubot/starbucks/' (req, resp) ->

	room_name = req.body.room
    message = req.body.message
 
    room_name = process.env.HUBOT_DEFAULT_POST_ROOM unless room_name
 
    robot.send {room: room_name}, message
    res.end "send #{room_name} #{message}"