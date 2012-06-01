IocContainerChecker =

	#проверять соответствие методов в обоих сущностях
	#TODO: вынести в отдельную сущность работы с АОП
	applyToIocContainerPrototype: (iocContainerPrototype) ->
		decoratedMethod = iocContainerPrototype::setSchema
		decorator = @setSchema
		iocContainerPrototype::setSchema = ->
			decorator.apply @, arguments
			decoratedMethod.apply @, arguments

		iocContainerPrototype::_checkSchemaElement = @_checkSchemaElement

	setSchema: (schema) ->
		assert schema?, 'Dependency schema should be given'
		schemaElements = (element for element of schema)
		assert schemaElements.length > 0, 'Dependency schema should be non-empty'
		allElementNames = (elName for elName of schema)
		@_checkSchemaElement elementName, elementDescription, allElementNames for elementName, elementDescription of schema

	_checkSchemaElement: (elementName, elementDescription, allElementNames) ->
		assertElement = (condition, message) ->
			assert condition, "invalid element '#{elementName}': " + message

		assertElement elementDescription?, 'contents not set'

		elementTypes = (elementPart for elementPart of elementDescription when elementPart in @_allowedTypes)

		assertElement elementTypes.length > 0, "has no type"
		assertElement elementTypes.length == 1, "has several types: #{elementTypes.join ', '}"

		elementType = elementTypes[0]
		creator = elementDescription[elementType]
		assertElement creator?, "part '#{elementType}' should have value"

		if elementType != 'ref'
			assertElement typeof creator == 'function', "part '#{elementType}' should be function"

		allAllowedParts = @_allowedTypes.concat 'deps'
		unknownParts = (part for part of elementDescription when part not in allAllowedParts)
		assertElement unknownParts.length == 0, "unknown description parts: #{unknownParts.join ', '}. allowed parts: #{allAllowedParts.join ', '}"

		if 'deps' of elementDescription
			deps = elementDescription.deps
			typeofDeps = if deps == null then 'null' else typeof elementDescription.deps
			assertElement typeofDeps == 'object' and (dep for dep of deps).length > 0, "deps should be non-empty dictionary, #{typeofDeps} given"

			for depName, depValue of deps
				assertElement typeof depValue == 'string', "dependency '#{depName}' should be a string"
				assertElement depValue in allElementNames, "dependency '#{depName}': schema doesn't have element '#{depValue}'"
