vows = require 'vows'
_ = require 'underscore'
assert = require 'assert'

sack = require '../src/sack'
testproblems = require './testproblems'

vows.describe('Sacks').addBatch(

    'New empty [1,1,1] sack':
        topic: new sack.Sack [1,1,1]
        'is an object': (t) ->
            assert.isObject(t)
        'is empty': (t) ->
            assert.isEmpty(t.contents)
        'says its empty': (t) ->
            assert.isTrue(t.isEmpty())
        'has value zero': (t) ->
            assert.equal(t.value(),0)
    'New Sack with one item':
        topic: ->
            sack = new sack.Sack [2,2,1]
            sack.pack testproblems.i1
            sack
        'has value 10': (t) ->
            assert.equal(t.value(),10)
        'contains the packed item': (t) ->
            assert.isTrue(t.contains testproblems.i1)
        'random returns the packed item': (t) ->
            assert.equal(t.giveRandom(),testproblems.i1)
        'reverserotate returns the packed item': (t) ->
            assert.equal(t.giveByReverseRotate(),testproblems.i1)
        'pack refuses the same item': (t) ->
            assert.isFalse(t.pack testproblems.i1)
).export(module)
