describe 'IocContainer', ->
	iocContainer = null
	beforeEach ->
		iocContainer = new IocContainer

	describe 'schema element contents meaning:', ->
		describe 'single', ->
			it 'returns the only instance of given class', ->
				class Foo
					constructor: -> @hello = 'Foo!'
				iocContainer.setSchema
					fooInstance:
						single: Foo

				foo1 = iocContainer.getElement 'fooInstance'
				expect(foo1.hello).toEqual 'Foo!'
				expect(iocContainer.getElement 'fooInstance').toBe foo1

		describe 'factoryFunction', ->
			it 'returns function to create new objects', ->
				class Foo
					getClassName: -> return 'foo'

				iocContainer.setSchema
					fooFactory:
						factoryFunction: Foo

				fooFactory = iocContainer.getElement 'fooFactory'
				foo1 = fooFactory()
				foo2 = fooFactory()

				expect(foo1.getClassName()).toEqual 'foo'
				expect(foo2).not.toBe foo1

			it 'returned function accepts only calls without args', ->
				class Foo
				iocContainer.setSchema
					fooFactory:
						factoryFunction: Foo
				fooFactory = iocContainer.getElement 'fooFactory'
				expect(-> fooFactory 'some argument').toThrow new AssertException "factoryFunction 'fooFactory' should be called without arguments"

		describe 'ref', ->
			it 'gets existing object by direct reference', ->
				foo = name: 'fooElement'
				iocContainer.setSchema
					fooInstance:
						ref: foo

				expect(iocContainer.getElement 'fooInstance').toBe foo
		describe 'deps', ->
			it 'sets element dependencies with other schema elements using their names in schema', ->
				iocContainer.setSchema
					fooInstance:
						single: ->
						deps:
							'_barProperty': 'barInstance'
					barInstance:
						single: ->

				fooInstance = iocContainer.getElement 'fooInstance'
				expect(fooInstance._barProperty).toBe iocContainer.getElement('barInstance')

	describe 'setSchema: sets dependency schema to use', ->
		it 'checks that schema is not empty', ->
			invalidSchemaException = new AssertException "Dependency schema should given and non-empty"
			for invalidSchema in [null, undefined, {}]
				do (invalidSchema) ->
					expect(-> iocContainer.setSchema invalidSchema).toThrow invalidSchemaException

	describe 'getElement: gets element by its name in schema', ->
		it 'checks that schema is set and contains element', ->
			getFoo = -> iocContainer.getElement 'foo'
			expect(getFoo).toThrow 'Dependency schema is not set'
			iocContainer.setSchema
				bar:
					single: ->
			expect(getFoo).toThrow 'Element \'foo\' not found in dependency schema'

