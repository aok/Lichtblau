_ = require 'underscore'

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

    fits = (a, b) ->
        _.all(_.map(_.zip(a, b), (t) -> t[0] <= t[1]))

    pack = (item) ->
        if fits item.weight,sack.space
            sack.space = subtract sack.space,item.weight
            sack.value += item.value
            true
        else
            false

    items = _.select(items, (item) -> pack item, sack)
    sack.contents = _.pluck(items,"id")
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

valuePerCubicWeight = (item) ->
    item.bang = item.value
    dilute = (wx) ->
        item.bang = item.bang / wx
    dilute w for w in item.weight

cubicValuePerCubicWeight = (item) ->
    item.bang = Math.pow(item.value,item.weight.length)
    dilute = (wx) ->
        item.bang = item.bang / wx
    dilute w for w in item.weight

tryManyAndChooseBest = (problem) ->
    solutions = [
        packInOrderOfValue(problem),
        packInOrderOfValuePerFirstWeightDimension(problem)
        packInOrderOfValuePerCubicWeight(problem),
        packInOrderOfCubicValuePerCubicWeight(problem)
    ]
    if problem.capacity.length >= 2
        solutions.push(packInOrderOfValuePerSecondWeightDimension(problem))
    if problem.capacity.length >= 3
        solutions.push(packInOrderOfValuePerThirdWeightDimension(problem))
    best = _.max(solutions, (sack) -> sack.value)
    console.log "Best algorithm was " + solutions.indexOf(best)
    best.contents

exports.bestSoFar = tryManyAndChooseBest
