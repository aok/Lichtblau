vows = require 'vows'
_ = require 'underscore'
assert = require 'assert'

algos = require '../src/algo'
sack = require '../src/sack'
testproblems = require './testproblems'

algo = algos.bestSoFar

runChallenges = () ->
    solutions = []

    doChallenge = (i,j) ->
        solutions.push algo testproblems.challenge(i,j)

    doRound = (i) ->
        doChallenge i,j for j in [1..6]

    doRound i for i in [1..4]

    solutions

vows.describe('Lichtblau').addBatch(
    'Calculating efficiency for item 1':
        topic: ->
            algos.valuePerSumWeight(testproblems.i3)
        'items bang per buck is 3': (t) ->
            assert.equal(t.bang,3)
    
    'Knapsack rules, when nothing fits':
        topic: -> algo testproblems.e0
        'Returns an array': (t) ->
            assert.isArray(t)
        'Array is empty': (t) ->
            assert.isEmpty(t)
    'Knapsack rules, when one fits':
        topic: -> algo testproblems.e1
        'Returns an array': (t) ->
            assert.isArray(t)
        'Returns [1]': (t) ->
            assert.deepEqual(t, ['1'])
    'Knapsack rules, when two would fit but one has max value':
        topic: algo testproblems.e2
        'Returns an array': (t) ->
            assert.isArray(t)
        'Returns [3]': (t) ->
            assert.deepEqual(t, ['3'])
    'Knapsack rules, for round 4 challenge 6':
        topic: algo testproblems.challenge(4,6)
        'Returns an array': (t) ->
            assert.isArray(t)
        'Return some results': (t) ->
            assert.notEqual(0,t.length)
        'Results are unique': (t) ->
            uniq = _.uniq(t)
            assert.equal(uniq?.length,t?.length)

#    'Basic validation for all example rounds':
#        topic: runChallenges()
#        'Returns an array of arrays': (t) ->
#            for a in t
#                assert.isArray(a)
).export(module)
