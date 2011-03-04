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

exports.homework = (problem) ->
    [problem?.contents[0]?.id,3]

stooped = (problem) ->
    []

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

packInOrderOfCubicValuePerCubicWeight = (problem) ->
    sortWithAndPack problem,cubicValuePerCubicWeight

packInOrderOfValuePerSumWeight = (problem) ->
    sortWithAndPack problem,valuePerSumWeight

cubicValuePerCubicWeight = (item) ->
    item.bang = Math.pow(item.value,item.weight.length)
    dilute = (wx) ->
        item.bang = item.bang / wx
    dilute w for w in item.weight
    
valuePerSumWeight = (item) ->
    item.bang = item.value / _.reduce(item.weight, ((memo, num) -> memo + num), 0)

randomTriesFromBestFraction = (problem, fraction=2, tries=100) ->
    items = sortWith problem.contents, valuePerSumWeight
    items = items[0...items.length/fraction]
    
    sacks = []
    
    newRandomSack = (i) ->
        items = _.sortBy(items, Math.random)
        sacks.push packFromPrioritisedList items, problem.capacity
        
    newRandomSack i for i in [0..tries]
    
    _.max(sacks, (sack) -> sack.value)

sortDiscardAndSortAgain = (problem) ->
    items = sortWith problem.contents, valuePerSumWeight
    items = items[0...items.length/2]
    
    sortWithAndPack problem, cubicValuePerCubicWeight


tryManyAndChooseBest = (problem) ->
    solutions = [
#        packInOrderOfCubicValuePerCubicWeight(problem),
        packInOrderOfValuePerSumWeight(problem),
        sortDiscardAndSortAgain(problem),
        randomTriesFromBestFraction(problem)
    ]

    values = _.pluck(solutions, "value")
    best = _.max(solutions, (sack) -> sack.value)
    console.log "Got values "+values+" - algo "+solutions.indexOf(best)+" wins"
    best.contents

exports.bestSoFar = tryManyAndChooseBest
