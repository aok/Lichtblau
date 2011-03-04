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

stooped = (obj) ->
    []

selectByBangForBuck = (obj, bangFunction) ->
    items = obj.contents

    _.map(items, bangFunction)
    items = _.sortBy(items, (item) -> -1*item.bang)

    substract = (a,b) ->
        _.map(_.zip(a,b), (tuple) -> tuple[0]-tuple[1])
    
    ctx = {
        value: 0
        space: obj.capacity
        contents: []
    }

    pack = (item) ->
        if exports.fits item.weight,ctx.space
            ctx.space = substract ctx.space,item.weight
            ctx.value += item.value
            true
        else
            false
    
    sack = _.select(items, (item) -> pack item, ctx)
    
    console.log ctx.value
    ctx.contents = _.pluck(sack,"id")
    ctx

valuePerFirstDimension = (item) ->
    item.bang = item.value / item.weight[0]

valuePerCubicWeight = (item) ->
    item.bang = item.value
    dilute = (wx) ->
        item.bang = item.bang / wx
    dilute w for w in item.weight

trySeveral = (obj) ->
    solutions = []
    solutions.push(selectByBangForBuck(obj, valuePerFirstDimension))
    solutions.push(selectByBangForBuck(obj, valuePerCubicWeight))
    solutions[0].contents

exports.bestSoFar = trySeveral

