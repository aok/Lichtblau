_ = require 'underscore'

exports.homework = (obj) ->
    [obj?.contents[0]?.id,3]

exports.stooped = (obj) ->
    []

exports.fits = (dimensions, capacity) ->
    stillFits = true
    compare = (t) ->
        stillFits = t[0] <= t[1] and stillFits

    tuples = _.zip(dimensions, capacity)
    compare pair for pair in tuples
    
    stillFits