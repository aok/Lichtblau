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


packFromPrioritisedList = (items, capacity) ->
    sack = {
        value: 0
        space: capacity
        contents: []
    }
    
    subtract = (a,b) ->
        _.map(_.zip(a,b), (tuple) -> tuple[0]-tuple[1])
    
    pack = (item) ->
        if exports.fits item.weight,sack.space
            sack.space = subtract sack.space,item.weight
            sack.value += item.value
            true
        else
            false
            
    sack.contents = _.pluck(_.select(items, (item) -> pack item, sack),"id")
    sack

sortWith = (items, bangFunction) ->
    _.map(items, bangFunction)
    _.sortBy(items, (item) -> -1*item.bang)

packInOrderOfValuePerCubicWeight = (obj) ->
    items = sortWith obj.contents, valuePerCubicWeight
    sack = packFromPrioritisedList items, obj.capacity
    console.log sack
    sack.contents

packInOrderOfValue = (obj) ->
    items = sortWith obj.contents, (item) -> item.bang = item.value
    sack = packFromPrioritisedList items, obj.capacity
    console.log sack
    sack.contents

packInOrderOfValuePerFirstWeightDimension = (obj) ->
    items = sortWith obj.contents, (item) -> item.bang = item.value / item.weight[0]
    sack = packFromPrioritisedList items, obj.capacity
    console.log sack
    sack.contents

valuePerCubicWeight = (item) ->
    item.bang = item.value
    dilute = (wx) ->
        item.bang = item.bang / wx
    dilute w for w in item.weight

exports.bestSoFar = packInOrderOfValuePerCubicWeight

