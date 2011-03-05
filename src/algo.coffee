_ = require 'underscore'
sack = require './sack'

sortWith = (items, bangf) ->
    _.sortBy(_.map(items, bangf), (item) -> -1*item.bang)

packNewSack = (items,capacity) ->
    sack = new sack.Sack capacity
    _.each(items, (item) -> (sack capacity).pack item)
    sack

# ### valuePerSumWeight(item)
# 
# Sums up all weight dimensions and divides value by it.
# Works when all weight dimensions are uniformly distributed in the same number space.
# Some normalisation would help for heterogeneous ranges, different distributions would be still harder.
valuePerSumWeight = (item) ->
    item.bang = item.value / _.reduce(item.weight, ((memo, num) -> memo + num), 0)


greedyThenSwap = (problem, tries) ->
    items = sortWith problem.contents, valuePerSumWeight
    sack = packNewSack items, problem.capacity
    return sack if sack.isEmpty()
    greedyValue = sack.value()
    
    successes = 0
    
    selectCandidates = () ->
        _.without items, sack.contents
    
    packDelta = (dropOut) ->
        #available capacity is dropout weight plus margin in sack
        available = _.map(_.zip(dropOut.weight,sack.capacity), (tuple) -> tuple[0]+tuple[1])
        # create a tiny sack to model the remaining capacity
        packNewSack(selectCandidates(dropOut),available)
    
    swap = () ->
        delta = packDelta sack.giveRandom()
        if delta.value > dropOut.value
            successes++
            sack.packList(delta.contents)

    swap() for i in [1..tries]

    if successes
        console.log "Improved from "+greedyValue+" to "+sack.value()+" with "+successes+" successful swaps on "+tries+" tries."
    else
        console.log "No improvement with "+usedTries+" tries."
    sack

exports.bestSoFar = (problem) ->
    _.pluck(greedyThenSwap(problem,problem.timeout/50).contents, "id")
