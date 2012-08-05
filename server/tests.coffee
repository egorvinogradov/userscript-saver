http = require 'http'
assert = require 'assert'

options =
	host: 'localhost'
	port: 3000
	path: '/server/taisties/example.ru'
	method: 'GET'

expected = [{
	rootUrl: 'example.ru'
	js: 'testjs'
	css: 'testcss'
	id: 'testid'
	name: 'testname'
	description: 'testdescription'
}]

request = http.request options, (taistiesResponse)->

	taistiesResponse.on "data", (data) ->

		cleanedData = data.toString().substr('Taist.applyTaisties('.length).replace(/\);$/, '')
		actual = JSON.parse cleanedData

		assert.equal(actual.length, expected.length, 'Wrong taistie count: ' + actual.length)

		actualElementsCount = ( element for element of actual[0] ).length
		expectedElementsCount = 6

		assert.equal(actualElementsCount, expectedElementsCount, 'Different elements count: ' + actualElementsCount + ', ' + expectedElementsCount)

		for key, value of expected[0]
			do (key, value)->
				assert.equal(actual[0][key], value, 'Wrong taistie content: ' + key)


request.on "error", (error) ->
	console.log 'On error', error

request.end()
