class IocContainerChecker
	#TODO: проверять соответствие методов в обоих сущностях
	#TODO: вынести в отдельную сущность работы с АОП
	applyToIocContainerPrototype: (iocContainerPrototype) ->
		@_addCheck iocContainerPrototype, checkedMethodName, check for checkedMethodName, check of @_getChecks()

	_addCheck: (checkedPrototype, methodName, check) ->
		decoratedMethod = checkedPrototype::[methodName]
		checker = this
		checkedPrototype::[methodName] = ->
			checkedObject = this
			argsArrayToConcat = (arg for arg in arguments)
			check.apply checker, [checkedObject].concat argsArrayToConcat
			decoratedMethod.apply checkedObject, arguments

	_getChecks: ->
		setSchema: (iocContainer, schema) ->
			assert schema?, 'Dependency schema should be given'
			schemaElements = (element for element of schema)
			assert schemaElements.length > 0, 'Dependency schema should be non-empty'
			allElementNames = (elName for elName of schema)
			@_checkSchemaElement iocContainer, elementName, elementDescription, allElementNames for elementName, elementDescription of schema

		_getElementDescriptor: (iocContainer, elementName) ->
			assert(iocContainer._schema?, 'Dependency schema is not set')
			rawElementData = iocContainer._schema[elementName]
			assert(rawElementData?, 'Element \'' + elementName + '\' not found in dependency schema')

	_checkSchemaElement: (iocContainer, elementName, elementDescription, allElementNames) ->
		#TODO: разобраться: с _allowedTypes - они не совсем в тему внутри самого контейнера, но и дублировать не хочется
		allowedTypes = iocContainer._allowedTypes
		assertElement = (condition, message) ->
			assert condition, "invalid element '#{elementName}': " + message

		assertElement elementDescription?, 'contents not set'

		elementType = @_getAndCheckElementType elementDescription, allowedTypes, assertElement

		creator = elementDescription[elementType]
		assertElement creator?, "part '#{elementType}' should have value"

		if elementType != 'ref'
			assertElement typeof creator == 'function', "part '#{elementType}' should be function"

		allAllowedParts = allowedTypes.concat 'deps'
		unknownParts = (part for part of elementDescription when part not in allAllowedParts)
		assertElement unknownParts.length == 0, "unknown description parts: #{unknownParts.join ', '}. allowed parts: #{allAllowedParts.join ', '}"

		if 'deps' of elementDescription
			deps = elementDescription.deps
			typeofDeps = if deps == null then 'null' else typeof elementDescription.deps
			assertElement typeofDeps == 'object' and (dep for dep of deps).length > 0, "deps should be non-empty dictionary, #{typeofDeps} given"

			for depName, depValue of deps
				assertElement typeof depValue == 'string', "dependency '#{depName}' should be a string"
				assertElement depValue in allElementNames, "dependency '#{depName}': schema doesn't have element '#{depValue}'"

	_getAndCheckElementType: (elementDescription, allowedTypes, assertFunction) ->
		elementTypes = (elementPart for elementPart of elementDescription when elementPart in allowedTypes)

		assertFunction elementTypes.length > 0, "has no type"
		assertFunction elementTypes.length == 1, "has several types: #{elementTypes.join ', '}"

		return elementTypes[0]


