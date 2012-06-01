describe 'IocContainerChecker', ->

	class CheckedIocContainer extends IocContainerBare

	IocContainerChecker.applyToIocContainerPrototype CheckedIocContainer

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
