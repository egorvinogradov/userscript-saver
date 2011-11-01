describe 'IocContainer', ->
	iocContainer = null
	beforeEach ->
		iocContainer = new IocContainer
		
	it 'returns the same new object if its constructor is given in \'single\'', ->
		class Foo
			constructor: -> @hello = 'Foo!'
		iocContainer.setSchema
			fooInstance:
				single: Foo

		foo1 = iocContainer.getElement 'fooInstance'
		expect(foo1.hello).toEqual 'Foo!'
		expect(iocContainer.getElement 'fooInstance').toBe foo1

	it 'returns function to create new objects if their constructor is given in \'factoryFunction\'', ->
		class Foo
			constructor: (name) -> @name = name
		iocContainer.setSchema
			fooFactory:
				factoryFunction: Foo

		factory = iocContainer.getElement 'fooFactory'
		foo1 = factory 'first'
		foo2 = factory 'second'

		expect(foo1.name).toEqual 'first'
		expect(foo2.name).toEqual 'second'

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
				single: ->
				deps:
					'_barProperty': 'barInstance'
			barInstance:
				single: ->

		fooInstance = iocContainer.getElement 'fooInstance'
		expect(fooInstance._barProperty).toBe iocContainer.getElement('barInstance')
