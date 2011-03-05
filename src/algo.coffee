_ = require 'underscore'

class Sack
    constructor: (@capacity, @value = 0, @contents = []) ->

    pack: (item) ->
        subtract = (a, b) ->
            _.map(_.zip(a,b), (tuple) -> tuple[0]-tuple[1])

        fits = (a, b) ->
            _.all(_.map(_.zip(a, b), (t) -> t[0] <= t[1]))

        if not _.include(@contents, item.id) and fits item.weight, @capacity
            @capacity = subtract @capacity, item.weight
            @value += item.value
            @contents.push(item.id)
            true
        else
            false

    drop: (item) ->
        add = (a, b) ->
            _.map(_.zip(a,b), (tuple) -> tuple[0]+tuple[1])

        if item?
            @contents = _.without @contents
            @capacity = add @capacity, item.weight
        else
            console.log "can't drop empty item"

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
    
# ### valuePerSumWeight(item)
# 
# Sums up all weight dimensions and divides value by it.
# Works when all weight dimensions are uniformly distributed in the same number space.
# Some normalisation would help for heterogeneous ranges, different distributions would be still harder.
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

greedyThenSwap = (problem, tries=100) ->
    sack = packInOrderOfValuePerSumWeight(problem)
    if sack?.contents?.length > 0
        items = sortWith problem.contents,valuePerSumWeight
        
        #selecting things to remove reverses through items added by greedy
        cursor = sack?.contents?.length

        selectDropOut = () ->
            if cursor > 0
                items[sack.contents[--cursor]]
        
        packDelta = (dropOut) ->
            # create a tiny sack to model the remaining capacity
            delta = new Sack _.map(_.zip(dropOut.weight,sack.capacity), (tuple) -> tuple[0]+tuple[1])
            ## consider refill from dropOut's position onward
            candidates = items[dropOut.id..items.length]
            ## try packing delta
            _.each(candidates, (item) -> delta.pack item)
            delta
        
        swap = () ->
            # choose one item to swap out
            dropOut = selectDropOut()
            if dropOut?
                delta = packDelta(dropOut)
                #see if it got any better
                improvement = delta.value-dropOut.value
                if improvement > 0
                    oldVal = sack.value
                    sack.drop dropOut
                    toPack = _.map(delta.contents, (id) -> items[id-1])
                    _.each(toPack, (item) -> sack.pack item)
                    newVal = sack.value

        swap() for i in [1..tries]
    else
        console.log "Can't improve on empty sack"
    sack

tryManyAndChooseBest = (problem) ->
    solutions = [
        randomTriesFromBestFraction(problem),
        greedyThenSwap(problem)
    ]

    values = _.pluck(solutions, "value")
    best = _.max(solutions, (sack) -> sack.value)
    console.log "Got values "+values+" - algo "+solutions.indexOf(best)+" wins"
    best.contents

exports.bestSoFar = tryManyAndChooseBest
