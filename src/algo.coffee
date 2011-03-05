_ = require 'underscore'

class Sack
    constructor: (@capacity, @value = 0, @contents = []) ->

    pack: (item) ->
        subtract = (a, b) ->
            _.map(_.zip(a,b), (tuple) -> tuple[0]-tuple[1])

        contains = (item) ->
            _.include(@contents, item)

        fits = (a, b) ->
            _.all(_.map(_.zip(a, b), (t) -> t[0] <= t[1]))

        if (not contains item) and (fits item.weight, @capacity)
            @capacity = subtract @capacity, item.weight
            @value += item.value
            @contents.push(item)
            true
        else
            false

    drop: (item) ->
        add = (a, b) ->
            _.map(_.zip(a,b), (tuple) -> tuple[0]+tuple[1])
        
        if item?
            newConts =  _.select @contents, (i) -> i.id != item.id
            
            if newConts.length < @contents
                @contents = newConts
                @capacity = add @capacity, item.weight
                @value -= item.value
                true
            else
                console.log "can't drop "+item.id+", it is not in the sack"
                false
        else
            console.log "can't drop empty item"
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
    
# ### valuePerSumWeight(item)
# 
# Sums up all weight dimensions and divides value by it.
# Works when all weight dimensions are uniformly distributed in the same number space.
# Some normalisation would help for heterogeneous ranges, different distributions would be still harder.
valuePerSumWeight = (item) ->
    item.bang = item.value / _.reduce(item.weight, ((memo, num) -> memo + num), 0)


greedyThenSwap = (problem, tries) ->
    items = sortWith problem.contents, valuePerSumWeight
    sack = packFromPrioritisedList items, problem.capacity
    greedyValue = sack.value
    
    if sack?.contents?.length > 0
        
        successes = 0
        usedTries = 0
        
        #selecting things to remove reverses through items added by greedy
        cursor = 0


        selectDropOut = () ->
            
            #FIXME - doesn't work
            rollBackWards = () ->
                if cursor == 1
                    cursor = sack?.contents?.length
                sack.contents[--cursor]

            #FIXME - doesn't work
            pickAtRandom = () ->
                idx = Math.floor(Math.random() * (sack.contents.length-1))
                sack.contents[idx]
            
            pickFirst = () ->
                sack.contents[0]
            
            pickAtRandom()
        
        selectCandidates = (dropOut) ->
            items[dropOut.id..items.length]
        
        packDelta = (dropOut) ->
            #available capacity is dropout weight plus margin in sack
            available = _.map(_.zip(dropOut.weight,sack.capacity), (tuple) -> tuple[0]+tuple[1])
            # create a tiny sack to model the remaining capacity
            delta = new Sack available
            ## consider refill from dropOut's position onward
            candidates = selectCandidates(dropOut)
            ## try packing delta
            _.each(candidates, (item) -> delta.pack item)
            delta
        
        swap = () ->
            # choose one item to swap out
            dropOut = selectDropOut()
            if dropOut
                delta = packDelta(dropOut)
                usedTries++
                
                #see if it got any better
                improvement = delta.value-dropOut.value
                if improvement > 0
                    #it did!
                    #execute swap, drop first
                    if sack.drop dropOut
                        successes++
                        #pack in delta
                        _.each(delta.contents, (item) -> sack.pack item)
                    else
                        console.log "misfire!"

        swap() for i in [1..tries]
    else
        console.log "Won't improve an empty sack"
    if successes
        console.log "Improved from "+greedyValue+" to "+sack.value+" with "+successes+" successful swaps on "+usedTries+" tries."
    else
        console.log "No improvement with "+usedTries+" tries."
    sack

exports.bestSoFar = (problem) ->
    sack = greedyThenSwap(problem,problem.timeout/50)
    ids = _.pluck(sack.contents, "id")
