_ = require 'underscore'

class Sack
    constructor: (@capacity, @contents = [], @available = [], @cursor = 0) ->

    isEmpty: () ->
        @contents.length < 1

    value: () ->
        _.reduce(@contents, ((memo, item) -> memo + item.value), 0)

    contains: (item) ->
        _.include(@contents, item)

    giveRandom: () ->
        idx = Math.floor(Math.random() * (@contents.length-1))
        @contents[idx]
    
    giveByReverseRotate: () ->
        if @cursor < 1
            @cursor = @content.length 
            console.log 'cursor: '+@cursor
        @contents[--@cursor]

    pack: (item) ->
        subtract = (a, b) ->
            _.map(_.zip(a,b), (tuple) -> tuple[0]-tuple[1])

        contains = (item) ->
            _.include(@contents, item)

        fits = (a, b) ->
            _.all(_.map(_.zip(a, b), (t) -> t[0] <= t[1]))

        if item? and (fits item.weight, @capacity) and not (this.contains item)
            @capacity = subtract @capacity, item.weight
            @contents.push(item)
            true
        else
            false

    packList: (items) ->
        _.all(_.map(items, (item) -> this.pack item))

    drop: (item) ->
        add = (a, b) ->
            _.map(_.zip(a,b), (tuple) -> tuple[0]+tuple[1])
        
        if item? and this.contains item
            newConts =  _.reject @contents, (inside) -> inside.id = item.id
            
            if newConts.length < @contents
                @contents = newConts
                @capacity = add @capacity, item.weight
                true
            else
                console.log "can't drop "+item.id+", it is not in the sack"
                false
        else
            console.log "can't drop empty item"
            false

exports.Sack = Sack