describe('IocConstructorWeavingAdvice', function() {
	var advice
	beforeEach(function() {
		advice = new IocConstructorWeavingAdvice()
	})
	it('weaves its method before _createFromConstructor', function() {
		var beforeMethodName, weavedMethod
		var weaver = {before: function(methodName, method) {
			beforeMethodName = methodName
			weavedMethod = method
		}}
		advice.execute(weaver, [])

		expect(beforeMethodName).toEqual('_createFromConstructor')
		expect(weavedMethod).toEqual(advice.applyAspectsToConstructor)
	})

	it('')
})