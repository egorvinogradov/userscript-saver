http = require 'http'
assert = require 'assert'
loadTaistie = require "./LoadTaistie"

expected = {
	rootUrl: 'example.ru'
	js: 'testjs'
	css: 'testcss'
	id: 'testid'
	name: 'testname'
	description: 'testdescription'
}

loadTaistie 'example.ru', (actual)->

	actualElementsCount = ( element for element of actual ).length
	expectedElementsCount = 6

	assert.equal(actualElementsCount, expectedElementsCount, 'Different elements count: ' + actualElementsCount + ', ' + expectedElementsCount)

	for key, value of expected
		do (key, value)->
			assert.equal(actual[key], value, 'Wrong taistie content: ' + key)

	console.log 'Unit test OK'


options =
	host: 'localhost'
	port: 3000
	path: '/server/taisties/example.ru'
	method: 'GET'


request = http.request options, (taistiesResponse)->

	taistiesResponse.on "data", (data) ->

		cleanedData = data.toString().substr('Taist.applyTaisties('.length).replace(/\);$/, '')
		actual = JSON.parse cleanedData

		assert.equal(actual.length, 1, 'Wrong taistie count: ' + actual.length)

		actualElementsCount = ( element for element of actual[0] ).length
		expectedElementsCount = 6

		assert.equal(actualElementsCount, expectedElementsCount, 'Different elements count: ' + actualElementsCount + ', ' + expectedElementsCount)

		for key, value of expected
			do (key, value)->
				assert.equal(actual[0][key], value, 'Wrong taistie content: ' + key)

		console.log 'Functional test OK'

request.on "error", (error) ->
	console.log 'On error', error

request.end()
