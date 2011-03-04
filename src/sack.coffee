_ = require 'underscore'

exports.Sack = (capacities) ->
    this.ids = []
    this.dims = (0 for item in capacities)
    this.capacities = capacities

exports.Sack.prototype.fits = (item) ->
    dimensions = _.zip(item.weight, this.dims, this.capacities)
    fit = (dimension) ->
        weight = dimension[0]
        dim = dimension[1]
        limit = dimension[2]
        (weight + dim <= limit)
    _.all(_.map(dimensions, fit))

exports.Sack.prototype.pack = (item) ->
    if fits item
        sack.ids.push(item.id)
        _.each(_.range(sack.dims.length), (dim) -> sack.dims[dim] += item.weight[dim])
        true
    else
        false
