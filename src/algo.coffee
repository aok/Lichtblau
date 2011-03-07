_ = require 'underscore'
sacks = require './sack'

# ### valuePerSumWeight(item)
# 
# Sums up all weight dimensions and divides value by it.
# Works when all weight dimensions are uniformly distributed in the same number space.
# Some normalisation would help for heterogeneous ranges, different distributions would be still harder.
exports.valuePerSumWeight = (item) ->
    sumOfWeights = _.reduce(item.weight, ((memo, num) -> memo + num), 0)
    item.bang = item.value / sumOfWeights
    item

sortWith = (items, bangf) ->
    _.sortBy(_.map(items, bangf), (item) -> -1*item.bang)



greedyThenSwap = (problem, tries) ->
    sack = new sacks.Sack problem.capacity
    items = sortWith problem.contents, exports.valuePerSumWeight
    sack.packList items
    return sack if sack.isEmpty()
    greedyValue = sack.value()
    
    successes = 0
    
    selectCandidates = () ->
        _.without items, sack.contents
    
    packDelta = (dropOut) ->
        #available capacity is dropout weight plus margin in sack
        available = _.map(_.zip(dropOut.weight,sack.capacity), (tuple) -> tuple[0]+tuple[1])
        # create a tiny sack to model the remaining capacity
        sack = new sacks.Sack available
        sack.packList selectCandidates
        sack
    
    swap = () ->
        dropOut = sack.giveRandom()
        delta = packDelta
        if delta.value > dropOut.value
            successes++
            sack.packList(delta.contents)

    swap() for i in [1..tries]

    if successes
        console.log "Improved from "+greedyValue+" to "+sack.value()+" with "+successes+" successful swaps on "+tries+" tries."
    else
        console.log "No improvement with "+tries+" tries."
    sack

exports.bestSoFar = (problem) ->
    _.pluck(greedyThenSwap(problem,problem.timeout/50).contents, "id")
