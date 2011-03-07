vows = require 'vows'
_ = require 'underscore'
assert = require 'assert'

sack = require '../src/sack'
testproblems = require './testproblems'

vows.describe('Sacks').addBatch(
    'New empty [1,1,1] sack':
        topic: -> new sack.Sack [1,1,1]
        'is an object': (t) ->
            assert.isObject(t)
        'is empty': (t) ->
            assert.isEmpty(t.contents)
        'says its empty': (t) ->
            assert.isTrue(t.isEmpty())
        'has value zero': (t) ->
            assert.equal(t.value(),0)
    'New Sack':
        topic: ->
            new sack.Sack [2,2,2]
        'has value 0': (t) ->
            assert.equal(t.value(),0)
        'after packing first item':
            topic: (t) ->
                t.pack testproblems.i1
                t 
            'has value 9': (t) ->
                assert.equal(t.value(),9)
            'contains the packed item': (t) ->
                assert.isTrue(t.contains testproblems.i1)
            'random returns the packed item': (t) ->
                assert.equal(t.giveRandom(),testproblems.i1)
            'reverserotate returns the packed item': (t) ->
                assert.equal(t.giveByReverseRotate(),testproblems.i1)
            'pack refuses the same item': (t) ->
                assert.isFalse(t.pack testproblems.i1)
            'and packing more':
                topic: (t) ->
                    answers = []
                    answers.push t.pack testproblems.i2
                    answers.push t.pack testproblems.i3
                    answers
                'second item is accepted': (t) ->
                    assert.isTrue(t[0])
                'third doesnt fit anymore': (t) ->
                    assert.isFalse(t[1])

    'New sack, packed with a list':
        topic: ->
            sack = new sack.Sack [2,2,2]
            sack.packList [testproblems.i1,testproblems.i2,testproblems.i3]
            sack
        'has two of the three items': (t) ->
            assert.equal(t.contents.length,2)
        'reverserotate returns the last item that fit in': (t) ->
            assert.equal(t.giveByReverseRotate(),testproblems.i2)
        
    

).export(module)
