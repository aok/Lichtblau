_ = require 'underscore'

exports.Sack = (capacity) ->
    console.log 'Creating a new Sack with capacity ' + capacity
    this.capacity = capacity
    this.contents =
        value:  0
        weight: 0
        items:  []
    console.log 'Returning sack with capacity ' + this.capacity
    console.log 'Initialized contents... '
    console.log '   value  ' + this.contents["value"]
    console.log '   weight ' + this.contents["weight"]
    console.log '   items  ' + this.contents["items"]

    this

exports.Sack.prototype.fits = (item) ->
    console.log 'Fitting item '+ item.id + ' with weight ' + item.weight
    console.log 'This capacity: ' + this.capacity
    dimensions = _.zip(item.weight, this.capacity)
    console.log 'Dimensions: ' + dimensions
    fit = (dimension) ->
        weight = dimension[0]
        capacity = dimension[1]
        (capacity - eight < 0)
    _.all(_.map(dimensions, fit))

exports.Sack.prototype.pack = (item) ->
    if this.fits item
        this.contents["items"].push(item.id)
        this.contents["value"] += item.value
        _.each(_.range(this.capacity.length), (dim) -> this.capacity[dim] -= item.weight[dim])
        true
    else
        false
