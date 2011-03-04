vows = require 'vows'
_ = require 'underscore'
assert = require 'assert'

algo = require '../src/algo'
testproblems = require './testproblems'

whattotest = algo.firstThatFits

vows.describe('Lichtblau').addBatch(
    'Homework':
        topic: algo.homework testproblems.e0
        'Returns an array of length 2': (topic) ->
            assert.equal(topic.length, 2)
        'Returns an array with first element 1': (topic) ->
            assert.equal(topic[0], 1)
        'Returns an array with second element 3': (topic) ->
            assert.equal(topic[1], 3)
        'Returns [1,3]': (topic) ->
            assert.deepEqual(topic, [1,3])
).addBatch(
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
    'Knapsack rules, when two fit':
        topic: whattotest testproblems.e2
        'Returns an array': (t) ->
            assert.isArray(t)
        'Returns [1, 2]': (t) ->
            assert.deepEqual(t, ['1', '2'])
    'Knapsack rules, for round0':
        topic: whattotest testproblems.round0()
        'Returns an array': (t) ->
            assert.isArray(t)
        'Return some results': (t) ->
            console.log t
            assert.notEqual(0,t.length)
            
).addBatch(
    'Fitting in one dimension':
        'when within capacity':
            topic: algo.fits([1], [2])
            'Returns true': (t) ->
                assert.isTrue(t)
        'when equal to capacity':
            topic: algo.fits([2], [2])
            'Returns true': (t) ->
                assert.isTrue(t)
        'above capacity':
            topic: algo.fits([3], [2])
            'Returns false': (t) ->
                assert.isFalse(t)
    'Fitting in two dimensions':
        'when both within capacity':
            topic: algo.fits([1,1], [2,1])
            'Returns true': (t) ->
                assert.isTrue(t)
        'when both equal to capacity':
            topic: algo.fits([2,2], [2,2])
            'Returns true': (t) ->
                assert.isTrue(t)
        '1st dimension above capacity':
            topic: algo.fits([3,1], [2,1])
            'Returns false': (t) ->
                assert.isFalse(t)
    'Fitting in three dimensions':
        'when all within capacity':
            topic: algo.fits([1,1,1], [2,2,2])
            'Returns true': (t) ->
                assert.isTrue(t)
        'when some equal to capacity':
            topic: algo.fits([2,1,1], [2,2,2])
            'Returns true': (t) ->
                assert.isTrue(t)
        'when some over capacity':
            topic: algo.fits([3,1,1], [2,2,2])
            'Returns false': (t) ->
                assert.isFalse(t)
).export(module)
