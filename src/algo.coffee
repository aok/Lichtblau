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

randomTriesFromBestFractionUntilTimeout = (problem, fraction=2, timeout=1000) ->
    items = sortWith problem.contents, valuePerSumWeight
    items = items[0...items.length/fraction]
    
    generator = () ->
        randomSack items, problem.capacity
    
    improveUntilTimeout generator(), generator, timeout

randomSack = (items, capacity) ->
    packFromPrioritisedList _.sortBy(items, Math.random), capacity


randomUntilTimeout = (problem, timeout=500) ->
    generator = () ->
        randomSack problem.contents, problem.capacity
    improveUntilTimeout generator(), generator, timeout

improveUntilTimeout = (start, generator, timeout=1000) ->
    
    sack = start
    
    tryAnother = () ->
        newSack = generator(sack)
        if newSack.value > sack.value
            sack = newSack

    dl = (new Date).getTime()+timeout
    tryAnother() while (new Date).getTime() < dl

    sack

tryManyAndChooseBest = (problem) ->
    solutions = [
        packInOrderOfValuePerSumWeight(problem),
        randomTriesFromBestFractionUntilTimeout(problem)
    ]

    values = _.pluck(solutions, "value")
    best = _.max(solutions, (sack) -> sack.value)
    console.log "Got values "+values+" - algo "+solutions.indexOf(best)+" wins"
    best.contents

exports.bestSoFar = tryManyAndChooseBest
