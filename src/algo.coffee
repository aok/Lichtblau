_ = require 'underscore'

exports.homework = (obj) ->
    [obj?.contents[0]?.id,3]

exports.stooped = (obj) ->
    [1,2,3]

exports.fits = (dimensions, capacity) ->
    tuples = _.zip(dimensions, capacity)
    console.log pair for pair in tuples
    false