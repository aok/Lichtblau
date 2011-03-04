_ = require 'underscore'

exports.fits = (dimensions, capacity) ->
    stillFits = true
    compare = (t) ->
        stillFits = t[0] <= t[1] and stillFits

    tuples = _.zip(dimensions, capacity)
    compare pair for pair in tuples
    
    stillFits

exports.homework = (problem) ->
    [problem?.contents[0]?.id,3]

stooped = (problem) ->
    []

packFromPrioritisedList = (items, capacity) ->
    sack = {
        value: 0
        space: capacity
        contents: []
    }

    subtract = (a,b) ->
        _.map(_.zip(a,b), (tuple) -> tuple[0]-tuple[1])

    pack = (item) ->
        if exports.fits item.weight,sack.space
            sack.space = subtract sack.space,item.weight
            sack.value += item.value
            true
        else
            false

    sack.contents = _.pluck(_.select(items, (item) -> pack item, sack),"id")
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

packInOrderOfValue = (problem) ->
    sortWithAndPack problem, (item) -> item.bang = item.value

packInOrderOfValuePerFirstWeightDimension = (problem) ->
    sortWithAndPack problem, (item) -> item.bang = item.value / item.weight[0]

packInOrderOfValuePerSecondWeightDimension = (problem) ->
    sortWithAndPack problem, (item) -> item.bang = item.value / item.weight[1]

packInOrderOfValuePerThirdWeightDimension = (problem) ->
    sortWithAndPack problem, (item) -> item.bang = item.value / item.weight[2]

valuePerCubicWeight = (item) ->
    item.bang = item.value
    dilute = (wx) ->
        item.bang = item.bang / wx
    dilute w for w in item.weight

tryThreeSortsAndReturnBest = (problem) ->
    solutions = [
        packInOrderOfValuePerCubicWeight(problem),
        packInOrderOfValue(problem),
        packInOrderOfValuePerFirstWeightDimension(problem)
    ]
    best = _.max(solutions, (sack) -> sack.value)
    best.contents

tryManyAndChooseBest = (problem) ->
    solutions = [
        packInOrderOfValuePerCubicWeight(problem),
        packInOrderOfValue(problem),
        packInOrderOfValuePerFirstWeightDimension(problem)
    ]
    if problem.capacity.length >= 2
        solutions.push(packInOrderOfValuePerSecondWeightDimension(problem))
    if problem.capacity.length >= 3
        solutions.push(packInOrderOfValuePerThirdWeightDimension(problem))
    best = _.max(solutions, (sack) -> sack.value)
    console.log "Best algorithm was " + solutions.indexOf(best)
    best.contents

exports.bestSoFar = tryManyAndChooseBest
