describe 'IocContainer', ->
	iocContainer = null
	beforeEach ->
		iocContainer = new IocContainerBare

	describe 'schema element contents meaning:', ->
		describe 'single', ->
			it 'returns the only instance of given class', ->
				class Foo
					constructor: -> @hello = 'Foo!'
				iocContainer.setSchema
					fooInstance:
						single: Foo

				foo1 = iocContainer.getInstance 'fooInstance'
				expect(foo1.hello).toEqual 'Foo!'
				expect(iocContainer.getInstance 'fooInstance').toBe foo1

		describe 'factoryFunction', ->
			it 'returns function to create new objects', ->
				class Foo
					getClassName: -> return 'foo'

				iocContainer.setSchema
					fooFactory:
						factoryFunction: Foo

				fooFactory = iocContainer.getInstance 'fooFactory'
				foo1 = fooFactory()
				foo2 = fooFactory()

				expect(foo1.getClassName()).toEqual 'foo'
				expect(foo2).not.toBe foo1

			it 'returned function accepts only calls without args', ->
				iocContainer.setSchema
					fooFactory:
						factoryFunction: ->
				fooFactory = iocContainer.getInstance 'fooFactory'
				expectAssertFail "factoryFunction 'fooFactory' should be called without arguments", ->
					fooFactory 'some argument'

		describe 'ref', ->
			it 'gets existing object by direct reference', ->
				foo = name: 'fooElement'
				iocContainer.setSchema
					fooInstance:
						ref: foo

				expect(iocContainer.getInstance 'fooInstance').toBe foo
		describe 'deps', ->
			it 'sets element dependencies with other schema elements using their names in schema', ->
				iocContainer.setSchema
					fooInstance:
						single: ->
						deps:
							'_barProperty': 'barInstance'
					barInstance:
						single: ->

				fooInstance = iocContainer.getInstance 'fooInstance'
				expect(fooInstance._barProperty).toBe iocContainer.getInstance('barInstance')

	describe 'setSchema: sets dependency schema to use', ->
		#TODO: добавить позитивные спеки

	describe 'getInstance: gets element by its name in schema', ->
		#TODO: добавить позитивные спеки

