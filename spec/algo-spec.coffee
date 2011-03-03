vows = require 'vows'
assert = require 'assert'

algo = require '../src/algo'

exampledata = {
    "name":"lol",
    "timeout":6000,
    "contents":[
        {"id":"1","weight":[10,20,30],"value":40},
        {"id":"2","weight":[40,50,60],"value":100},
        {"id":"3","weight":[30,60,90],"value":200}
    ],
    "capacity":[99,10,1000]
}

vows.describe('Algo').addBatch(
    'Homework':
        topic: algo.homework exampledata
        'Returns an array of length 2': (topic) ->
            assert.equal(topic.length, 2)
        'Returns an array with first element 1': (topic) ->
            assert.equal(topic[0], 1)
        'Returns an array with second element 3': (topic) ->
            assert.equal(topic[1], 3)
        'Returns [1,3]': (topic) ->
            assert.deepEqual(topic, [1,3])

#   'Homework':
#        topic: algo.takeUntilFull examplewnames
#        'Returns an array of integers': (topic) ->
#            assert.equal(topic.length, 2)
#

).export(module)


