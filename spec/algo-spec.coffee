vows = require 'vows'
_ = require 'underscore'
assert = require 'assert'

algo = require '../src/algo'
testproblems = require './testproblems'

whattotest = algo.bestSoFar

runChallenges = () ->    
    solutions = []
    
    doChallenge = (i,j) ->
        solutions.push whattotest testproblems.challenge(i,j)
    
    doRound = (i) ->
        doChallenge i,j for j in [1..6]
    
    doRound i for i in [1..4]
    
    solutions

loops = (max, timeout) ->
    i = 0
    dl = (new Date).getTime()+timeout
    i++ while i < max and (new Date).getTime() < dl
    i

vows.describe('Lichtblau').addBatch(
    'Clock-based timeout with inrement loop':
        'returns upper limit when limit is low and timeout long':
            topic: loops(1000,10)
            'Returns 1000': (t) ->
                assert.equal(t,1000)
        'returns under limit when limit is hihg and timeout short':
            topic: loops(99999999999,3000)
            'Returns less than max ': (t) ->
                assert.isTrue(t<99999999999) 
    'Knapsack rules, when nothing fits':
        topic: whattotest testproblems.e0
        'Returns an array': (t) ->
            assert.isArray(t)
        'Array is empty': (t) ->
            assert.isEmpty(t)
    'Knapsack rules, when one fits':
        topic: whattotest testproblems.e1
        'Returns an array': (t) ->
            assert.isArray(t)
        'Returns [1]': (t) ->
            assert.deepEqual(t, ['1'])
    'Knapsack rules, when two would fit but one has max value':
        topic: whattotest testproblems.e2
        'Returns an array': (t) ->
            assert.isArray(t)
        'Returns [3]': (t) ->
            assert.deepEqual(t, ['3'])
    
    'Knapsack rules, for round0':
        topic: whattotest testproblems.challenge(0,1)
        'Returns an array': (t) ->
            assert.isArray(t)
        'Return some results': (t) ->
            assert.notEqual(0,t.length)
    
    'Basic validation for all example rounds':
        topic: runChallenges()
        'Returns an array of arrays': (t) ->
            assert.isArray(t)
).export(module)
