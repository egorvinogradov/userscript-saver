describe 'IocContainer', ->
	iocContainer = null
	beforeEach ->
		iocContainer = new IocContainer
		
	it 'creates new object if its constructor given in \'ctor\'', ->
		class Foo
			constructor: -> @name = 'foo'
		iocContainer.setSchema
			fooInstance:
				ctor: Foo

		expect(iocContainer.getElement 'fooInstance').toEqual new Foo

	it 'gets existing object if its reference given in \'reference\'', ->
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

	it 'returns the same element again for the same name', ->
		iocContainer.setSchema
			fooInstance:
				ctor: ->

		fooInstance = iocContainer.getElement 'fooInstance'
		expect(iocContainer.getElement 'fooInstance').toBe fooInstance

	it 'sets element dependencies', ->
		iocContainer.setSchema
			fooInstance:
				ctor: ->
				deps:
					'_barProperty': 'barInstance'
			barInstance:
				ctor: ->

		fooInstance = iocContainer.getElement 'fooInstance'
		expect(fooInstance._barProperty).toBe iocContainer.getElement('barInstance')