_ = require 'underscore'

exports.fits = (dimensions, capacity) ->
    stillFits = true
    compare = (t) ->
        stillFits = t[0] <= t[1] and stillFits

    tuples = _.zip(dimensions, capacity)
    compare pair for pair in tuples
    
    stillFits

exports.homework = (obj) ->
    [obj?.contents[0]?.id,3]

exports.stooped = (obj) ->
    []

exports.selectByBangForBuck = (obj) ->
    items = obj.contents
    _.map(items, (item) -> item.bang = item.value / item.weight[0])
    items = _.sortBy(items, (item) -> -1*item.bang)

    substract = (a,b) ->
        _.map(_.zip(a,b), (tuple) -> tuple[0]-tuple[1])
    
    ctx = {
        space: obj.capacity
    }

    pack = (item) ->
        if exports.fits item.weight,ctx.space
            ctx.space = substract ctx.space,item.weight
            true
        else
            false
    
    sack = _.select(items, (item) -> pack item, ctx)
    
    _.pluck(sack,"id")






