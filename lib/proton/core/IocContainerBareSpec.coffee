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
				iocContainer.setSchema
					fooFactory:
						factoryFunction: ->
				fooFactory = iocContainer.getElement 'fooFactory'
				expectAssertFail "factoryFunction 'fooFactory' should be called without arguments", ->
					fooFactory 'some argument'

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
			for invalidSchema in [null, undefined, {}]
				do (invalidSchema) ->
					assertMessage = if not invalidSchema? then 'Dependency schema should be given' else 'Dependency schema should be non-empty'
					expectAssertFail assertMessage, ->
						iocContainer.setSchema invalidSchema

		describe 'it checks each element in schema', ->

			assertInvalidSchema = (assertMessage, invalidSchema) ->
				completeMessage = 'invalid element \'foo\': ' + assertMessage
				expectAssertFail completeMessage, -> iocContainer.setSchema invalidSchema

			itAssertsSchema = (specDescription, assertMessage, invalidSchema) ->
				it specDescription, -> assertInvalidSchema assertMessage, invalidSchema

			itAssertsSchema 'should have only one type', 'has several types: single, factoryFunction',
				foo:
					single: ->
					factoryFunction: ->
			itAssertsSchema 'should have contents', 'contents not set', foo: null
			itAssertsSchema 'type should be given', 'has no type', foo: {}

			allAllowedTypes = ['single', 'ref', 'factoryFunction']
			for creator in allAllowedTypes
				do (creator) ->
					nullDescription = foo: {}

					nullDescription.foo[creator] = null
					itAssertsSchema "part '#{creator}' should have value", "part '#{creator}' should have value", nullDescription

					if creator != 'ref'
						nonFunctionDescription = foo: {}
						nonFunctionDescription.foo[creator] = {}
						itAssertsSchema "part '#{creator}' should be function", "part '#{creator}' should be function", nonFunctionDescription

			allowedParts = "allowed parts: #{allAllowedTypes.join ', '}, deps"
			itAssertsSchema 'should have only allowed parts', "unknown description parts: bar, baz. " + allowedParts,
				foo:
					single: ->
					bar: null
					baz: {}

			it 'deps should be non-empty dictionary', ->
				for invalidDeps in [undefined, null, 'invalid', {}]
					do (invalidDeps) ->
						typeofDeps = if invalidDeps == null then 'null' else typeof invalidDeps
						assertInvalidSchema "deps should be non-empty dictionary, #{typeofDeps} given",
							foo:
								single: ->
								deps: invalidDeps

			it 'each dependency should be a string name of other element in schema', ->
				for invalidDep in [null, {}]
					do (invalidDep) ->
						assertInvalidSchema "dependency 'barProperty' should be a string",
							foo:
								single: ->
								deps:
									barProperty: invalidDep
				assertInvalidSchema "dependency 'barProperty': schema doesn't have element 'bar'",
					foo:
						single: ->
						deps:
							barProperty: 'bar'

	describe 'getElement: gets element by its name in schema', ->
		it 'checks that schema is set and contains element', ->
			getFoo = -> iocContainer.getElement 'foo'
			expectAssertFail 'Dependency schema is not set', getFoo
			iocContainer.setSchema
				bar:
					single: ->
			expectAssertFail 'Element \'foo\' not found in dependency schema', getFoo

