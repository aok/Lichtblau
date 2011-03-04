vows = require 'vows'
_ = require 'underscore'
assert = require 'assert'

algo = require '../src/algo'
testproblems = require './testproblems'

whattotest = algo.bestSoFar

vows.describe('Lichtblau').addBatch(
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

    'Knapsack rules, for round 1':
        'Challenge 1':
            topic: whattotest testproblems.challenge(1,1)
            'Returns an array': (t) ->
                assert.isArray(t)
            'Return some results': (t) ->
                assert.notEqual(0,t.length)
        'Challenge 2':
            topic: whattotest testproblems.challenge(1,2)
            'Returns an array': (t) ->
                assert.isArray(t)
            'Return some results': (t) ->
                assert.notEqual(0,t.length)
        'Challenge 3':
            topic: whattotest testproblems.challenge(1,3)
            'Returns an array': (t) ->
                assert.isArray(t)
            'Return some results': (t) ->
                assert.notEqual(0,t.length)
        'Challenge 4':
            topic: whattotest testproblems.challenge(1,4)
            'Returns an array': (t) ->
                assert.isArray(t)
            'Return some results': (t) ->
                assert.notEqual(0,t.length)
        'Challenge 5':
            topic: whattotest testproblems.challenge(1,5)
            'Returns an array': (t) ->
                assert.isArray(t)
            'Return some results': (t) ->
                assert.notEqual(0,t.length)
        'Challenge 6':
            topic: whattotest testproblems.challenge(1,6)
            'Returns an array': (t) ->
                assert.isArray(t)
            'Return some results': (t) ->
                assert.notEqual(0,t.length)

    'Knapsack rules, for round 2':
        'Challenge 1':
            topic: whattotest testproblems.challenge(2,1)
            'Returns an array': (t) ->
                assert.isArray(t)
            'Return some results': (t) ->
                assert.notEqual(0,t.length)
        'Challenge 2':
            topic: whattotest testproblems.challenge(2,2)
            'Returns an array': (t) ->
                assert.isArray(t)
            'Return some results': (t) ->
                assert.notEqual(0,t.length)
        'Challenge 3':
            topic: whattotest testproblems.challenge(2,3)
            'Returns an array': (t) ->
                assert.isArray(t)
            'Return some results': (t) ->
                assert.notEqual(0,t.length)
        'Challenge 4':
            topic: whattotest testproblems.challenge(2,4)
            'Returns an array': (t) ->
                assert.isArray(t)
            'Return some results': (t) ->
                assert.notEqual(0,t.length)
        'Challenge 5':
            topic: whattotest testproblems.challenge(2,5)
            'Returns an array': (t) ->
                assert.isArray(t)
            'Return some results': (t) ->
                assert.notEqual(0,t.length)
        'Challenge 6':
            topic: whattotest testproblems.challenge(2,6)
            'Returns an array': (t) ->
                assert.isArray(t)
            'Return some results': (t) ->
                assert.notEqual(0,t.length)
).export(module)
