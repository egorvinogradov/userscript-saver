describe 'IocContainerChecker', ->
	iocContainer = null
	IocContainerChecker.applyToIocContainerPrototype IocContainerBare

	beforeEach ->
		iocContainer = new IocContainerBare

	describe 'setSchema', ->
		it 'checks that schema is not empty', ->
			for invalidSchema in [null, undefined, {}]
				do (invalidSchema) ->
					assertMessage = if not invalidSchema? then 'Dependency schema should be given' else 'Dependency schema should be non-empty'
					expectAssertFail assertMessage, ->
						iocContainer.setSchema invalidSchema
