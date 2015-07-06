module.exports = (robot, req) ->
    data = req.body
    if !data.alert or data.alert.status != 'ok'
        return "pass"
    hit = process.env.STARBUCKS_HIT or 1
    rand = Math.floor(Math.random() * hit)
    if rand != 0
        return "miss #{rand}"

    return true