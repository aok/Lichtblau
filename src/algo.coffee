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

packInOrderOfValuePerCubicWeight = (problem) ->
    sortWithAndPack problem,valuePerCubicWeight

packInOrderOfCubicValuePerCubicWeight = (problem) ->
    sortWithAndPack problem,cubicValuePerCubicWeight

packInOrderOfValue = (problem) ->
    sortWithAndPack problem, (item) -> item.bang = item.value

packInOrderOfValuePerFirstWeightDimension = (problem) ->
    sortWithAndPack problem, (item) -> item.bang = item.value / item.weight[0]

packInOrderOfValuePerSecondWeightDimension = (problem) ->
    sortWithAndPack problem, (item) -> item.bang = item.value / item.weight[1]

packInOrderOfValuePerThirdWeightDimension = (problem) ->
    sortWithAndPack problem, (item) -> item.bang = item.value / item.weight[2]

nDilute = (item) ->
    dilute = (wx) ->
        item.bang = item.bang / wx
    dilute w for w in item.weight
    

valuePerCubicWeight = (item) ->
    item.bang = item.value
    nDilute item

cubicValuePerCubicWeight = (item) ->
    item.bang = Math.pow(item.value,item.weight.length)
    nDilute item

randomTriesFromBestThird = (problem) ->
    items = sortWith problem.contents, cubicValuePerCubicWeight
    items = items[0...items.length/3]
    
    tries = [0..10]
    sacks = []
    
    newRandomSack = (i) ->
        items = _.sortBy(items, Math.random)
        sacks.push packFromPrioritisedList items, problem.capacity
        
    newRandomSack i for i in [0..100]
    
    _.max(sacks, (sack) -> sack.value)

tryManyAndChooseBest = (problem) ->
    solutions = [
        packInOrderOfValue(problem),
        packInOrderOfValuePerFirstWeightDimension(problem)
        packInOrderOfValuePerCubicWeight(problem),
        packInOrderOfCubicValuePerCubicWeight(problem),
        randomTriesFromBestThird(problem)
    ]
    if problem.capacity.length >= 2
        solutions.push(packInOrderOfValuePerSecondWeightDimension(problem))
    if problem.capacity.length >= 3
        solutions.push(packInOrderOfValuePerThirdWeightDimension(problem))
    best = _.max(solutions, (sack) -> sack.value)
    console.log "Best algorithm was " + solutions.indexOf(best)
    best.contents

exports.bestSoFar = tryManyAndChooseBest
