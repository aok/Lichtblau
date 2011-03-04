_ = require 'underscore'

class Sack
    constructor: (@capacity, @value = 0, @contents = []) ->

    pack: (item) ->
        subtract = (a, b) ->
            _.map(_.zip(a,b), (tuple) -> tuple[0]-tuple[1])

        fits = (a, b) ->
            _.all(_.map(_.zip(a, b), (t) -> t[0] <= t[1]))

        if fits item.weight, @capacity
            @capacity = subtract @capacity, item.weight
            @value += item.value
            @contents.push(item.id)
            true
        else
            false
    
    drop: (item) ->
        add = (a, b) ->
            _.map(_.zip(a,b), (tuple) -> tuple[0]+tuple[1])

        @contents = _.without @contents
        @capacity = add @capacity, item.weight

packFromPrioritisedList = (items, capacity) ->
    sack = new Sack capacity
    _.each(items, (item) -> sack.pack item)
    sack

sortWith = (items, bangFunction) ->
    _.map(items, bangFunction)
    _.sortBy(items, (item) -> -1*item.bang)

sortWithAndPack = (problem, f) ->
    items = sortWith problem.contents, f
    sack = packFromPrioritisedList items, problem.capacity
    sack

packInOrderOfValuePerSumWeight = (problem) ->
    sortWithAndPack problem,valuePerSumWeight
    
valuePerSumWeight = (item) ->
    item.bang = item.value / _.reduce(item.weight, ((memo, num) -> memo + num), 0)

randomTriesFromBestFraction = (problem, fraction=10, tries=1000) ->
    items = sortWith problem.contents, valuePerSumWeight
    items = items[0...items.length/fraction]
    
    sacks = []
    
    newRandomSack = () ->
        items = _.sortBy(items, Math.random)
        sacks.push packFromPrioritisedList items, problem.capacity
        
    newRandomSack() for i in [0..tries]
    
    _.max(sacks, (sack) -> sack.value)

tryManyAndChooseBest = (problem) ->
    solutions = [
        packInOrderOfValuePerSumWeight(problem),
        randomTriesFromBestFraction(problem)
    ]

    values = _.pluck(solutions, "value")
    best = _.max(solutions, (sack) -> sack.value)
    console.log "Got values "+values+" - algo "+solutions.indexOf(best)+" wins"
    best.contents

exports.bestSoFar = tryManyAndChooseBest
