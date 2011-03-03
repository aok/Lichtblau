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
    
exports.firstThatFits = (obj) ->
    capacity = obj.capacity
    items = obj.contents
    
    itemFits = (item) ->
        exports.fits item.weight,capacity

    allThatWouldFit = _.select(items, itemFits) 
    fitting = _.first allThatWouldFit
    _.toArray(fitting?.id)