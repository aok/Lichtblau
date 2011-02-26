vows = require 'vows'
assert = require 'assert'

algo = require './algo'

vows.describe('Algo').addBatch(
	'Homework':
		topic: algo.homework
		'Returns an array of length 2': (topic) ->
			assert.equal(topic.length, 2)
		'Returns an array with first element 1': (topic) ->
			assert.equal(topic[0], 1)
		'Returns an array with second element 3': (topic) ->
			assert.equal(topic[1], 3)
		'Returns [1,3]': (topic) ->
			assert.deepEqual(topic, [1,3])
).export(module)
