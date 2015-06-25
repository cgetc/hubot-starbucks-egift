hit = process.env.STARBUCKS_HIT

module.exports = (data) ->
	if data.alert.status != 'ok'
        return "pass"

    rand = Math.floor(Math.random() * hit)
    if rand != 0
        return "miss #{rand}"

    return true