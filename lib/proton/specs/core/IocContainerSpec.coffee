describe 'IocContainer', ->
	iocContainer = null
	beforeEach ->
		iocContainer = new IocContainer
		
	it 'returns the same new object if its constructor given in \'singleton\'', ->
		class Foo
			constructor: -> @hello = 'Foo!'
		iocContainer.setSchema
			fooInstance:
				singleton: Foo

		foo1 = iocContainer.getElement 'fooInstance'
		expect(foo1.hello).toEqual 'Foo!'
		expect(iocContainer.getElement 'fooInstance').toBe foo1

	it 'gets existing object if its reference given in \'ref\'', ->
		foo = name: 'fooElement'
		iocContainer.setSchema
			fooInstance:
				ref: foo

		expect(iocContainer.getElement 'fooInstance').toBe foo

	it 'checks that schema is set and contains element', ->

		getFoo = -> iocContainer.getElement 'fooInstance'
		expect(getFoo).toThrow 'Dependency schema is not set'
		iocContainer.setSchema {}
		expect(getFoo).toThrow 'Element \'fooInstance\' not found in dependency schema'

	it 'sets element dependencies', ->
		iocContainer.setSchema
			fooInstance:
				singleton: ->
				deps:
					'_barProperty': 'barInstance'
			barInstance:
				singleton: ->

		fooInstance = iocContainer.getElement 'fooInstance'
		expect(fooInstance._barProperty).toBe iocContainer.getElement('barInstance')
