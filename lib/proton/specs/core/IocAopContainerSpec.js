describe('IocAopContainerSpec', function() {
	var aopContainer
	beforeEach(function() {
		aopContainer = new IocAopContainer()
	})

	it('calls parent method to return new element', function() {
		var ctorFunction = function(){this.foo = 'bar'}
		var element = aopContainer._createFromConstructor(ctorFunction)
		expect(element).toEqual({foo: 'bar'})
	})

})