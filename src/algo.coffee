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
    selectedItem = _.first allThatWouldFit
    id = selectedItem?.id
    if id
        return [id]
    else
        return []

exports.oneThatFits = (obj) ->

    sack =
        ids:    []
        dims:   (0 for item in obj.capacity)

    fits = (item) ->
        dimensions = _.zip(item.weight, sack.dims, obj.capacity)
        fit = (dimension) ->
            weight = dimension[0]
            dim = dimension[1]
            limit = dimension[2]
            (weight + dim <= limit)
        _.all( _.map(dimensions, fit))

    pack = (item) ->
        sack.ids += item.id
        sack.dim1 += item.weight[0]
        sack.dim2 += item.weight[1] if (obj.capacity.length >= 2)
        sack.dim3 += item.weight[2] if (obj.capacity.length >= 3)

    pack sack, (_.first _.select obj.contents, fits)
    _.toArray sack.ids

exports.singlePassIterationPack = (obj) ->

    sack =
        ids:    []
        dims:   (0 for item in obj.capacity)

    fits = (item) ->
        dimensions = _.zip(item.weight, sack.dims, obj.capacity)
        fit = (dimension) ->
            weight = dimension[0]
            dim = dimension[1]
            limit = dimension[2]
            (weight + dim <= limit)
        _.all(_.map(dimensions, fit))

    pack = (item) ->
        if fits item
            sack.ids.push(item.id)
            #for dim in _.range(sack.dims)
            #    sack.dims[dim] += item.weight[dim]
            _.each(_.range(sack.dims.length), (dim) -> sack.dims[dim] += item.weight[dim])

    _.each obj.contents, pack
    _.toArray sack.ids
