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

# Unit test (returns taistie as an object)

path =
  join: (folder, file) ->
    folder + '/' + file

fs =
	data:
		'server/taisties/example.ru.css': 'testcss'
		'server/taisties/example.ru.js': 'testjs'
		'server/taisties/example.ru.id': 'testid'
		'server/taisties/example.ru.name': 'testname'
		'server/taisties/example.ru.description': 'testdescription'
	exists: (filePath, callback)->
		callback filePath of @data
	readFile: (filePath, callback)->
		callback null, @data[filePath]

loadTaistieSuccess = (actual) ->

	actualElementsCount = ( element for element of actual ).length
	expectedElementsCount = 6

	assert.equal(actualElementsCount, expectedElementsCount, 'Different elements count: ' + actualElementsCount + ', ' + expectedElementsCount)

	for key, value of expected
		do (key, value)->
			assert.equal(actual[key], value, 'Wrong taistie content: ' + key)

	console.log 'Unit test for exanple.ru complete'

loadTaistieError = (error) ->
	assert.fail('Unxpected error', error.message)


loadTaistie fs, path, 'example.ru',
	success: loadTaistieSuccess
	error: loadTaistieError


# Returns error on unexisting taistie

callbackWasCalled = false

loadTaistie fs, path, 'unexisting.ru',
	error: (error) ->
		callbackWasCalled = true
		assert.equal(error.message, 'Taistie for unexisting.ru not found', 'Wrong error message')
		console.log 'Test for unexisting OK'

checkState = ->
	assert.ok(callbackWasCalled, 'Error callback wasn\'t called')

setTimeout checkState, 100

