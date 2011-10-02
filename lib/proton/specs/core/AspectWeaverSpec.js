describe('AspectWeaver', function() {
	var weaver
	var constructorFunction
	beforeEach(function() {
		weaver = new AspectWeaver()
		constructorFunction = function() {}
		weaver._constructorFunction = constructorFunction
	})
	it('adds new method to prototype', function() {
		var newMethod = function(){}
		weaver.add('newMethod', newMethod)
		expect(constructorFunction.prototype['newMethod']).toEqual(newMethod)
	})

	it('adds after-advice', function() {
		constructorFunction.prototype.fooMethod = function(argument){return argument + argument}
		weaver.after('fooMethod', function(returnValue, argument) {
			return argument + '->' + returnValue
		})

		var obj = new constructorFunction()

		expect(obj.fooMethod('bar')).toEqual('bar->barbar')
	})
})