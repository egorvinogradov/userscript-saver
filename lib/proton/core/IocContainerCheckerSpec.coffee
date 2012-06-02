describe 'IocContainerChecker', ->

	class CheckedIocContainer extends IocContainerBare

	checker = new IocContainerChecker
	checker.applyToIocContainerPrototype CheckedIocContainer

	iocContainer = null
	beforeEach ->
		iocContainer = new CheckedIocContainer

	describe 'setSchema', ->
		it 'checks that schema is not empty', ->
			for invalidSchema in [null, undefined, {}]
				do (invalidSchema) ->
					assertMessage = if not invalidSchema? then 'Dependency schema should be given' else 'Dependency schema should be non-empty'
					expectAssertFail assertMessage, ->
						iocContainer.setSchema invalidSchema

		describe 'it checks each instance in schema', ->

			#TODO: разбить на отдельные спеки по смыслу
			assertInvalidSchema = (assertMessage, invalidSchema) ->
				completeMessage = 'invalid instance \'foo\': ' + assertMessage
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

			it 'each dependency should be a string name of other instance in schema', ->
				for invalidDep in [null, {}]
					do (invalidDep) ->
						assertInvalidSchema "dependency 'barProperty' should be a string",
							foo:
								single: ->
								deps:
									barProperty: invalidDep
				assertInvalidSchema "dependency 'barProperty': schema doesn't have instance 'bar'",
					foo:
						single: ->
						deps:
							barProperty: 'bar'

	describe 'getInstance', ->
		it 'checks that schema is set and contains instance', ->
			getFoo = -> iocContainer.getInstance 'foo'
			expectAssertFail 'Dependency schema is not set', getFoo
			iocContainer.setSchema
				bar:
					single: ->
			expectAssertFail 'Instance \'foo\' not found in dependency schema', getFoo
