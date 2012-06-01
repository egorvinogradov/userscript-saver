IocContainerChecker =

	#проверять соответствие методов в обоих сущностях
	#TODO: вынести в отдельную сущность работы с АОП
	applyToIocContainerPrototype: (iocContainerPrototype) ->
		decoratedMethod = iocContainerPrototype::setSchema
		decorator = @setSchema
		iocContainerPrototype::setSchema = ->
			decorator.apply @, arguments
			decoratedMethod.apply @, arguments

	setSchema: (schema) ->
		assert schema?, 'Dependency schema should be given'
		schemaElements = (element for element of schema)
		assert schemaElements.length > 0, 'Dependency schema should be non-empty'
