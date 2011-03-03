vows = require 'vows'
assert = require 'assert'

algo = require '../src/algo'

obj = {
    "a":"lol",
    "b":6000,
    "c":[
        {"id":1,"e":[10, 20, 30],"f":40},
        {"id":2,"e":[40,50,60],"f":100},
        {"id":3,"e":[30,60,90],"f":200}
    ],
    "g":[99,10,1000]
}

vows.describe('Algo').addBatch(
    'Homework':
        topic: algo.homework obj
        'Returns an array of length 2': (topic) ->
            assert.equal(topic.length, 2)
        'Returns an array with first element 1': (topic) ->
            assert.equal(topic[0], 1)
        'Returns an array with second element 3': (topic) ->
            assert.equal(topic[1], 3)
        'Returns [1,3]': (topic) ->
            assert.deepEqual(topic, [1,3])
).export(module)
