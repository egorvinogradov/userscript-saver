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
			elementNames = (elementName for elementName, elementDescription of schema)
			assert elementNames.length > 0, 'Dependency schema should be non-empty'

			(new _schemaElementChecker elementName, schema).check() for elementName in elementNames

		_getElementDescriptor: (iocContainer, elementName) ->
			assert iocContainer._schema?, 'Dependency schema is not set'
			rawElementData = iocContainer._schema[elementName]
			assert rawElementData?, 'Element \'' + elementName + '\' not found in dependency schema'

	class _schemaElementChecker
		constructor: (@elementName, @schema) ->
			@elementDescription = @schema[@elementName]

		_keySourceSingle: 'single'
		_keySourceReference: 'ref'
		_keySourceFactoryFunction: 'factoryFunction'
		_keyDependencies: 'deps'

		_getAllowedTypes: -> [@_keySourceSingle, @_keySourceReference, @_keySourceFactoryFunction]

		check: ->
			@_assertElement @elementDescription?, 'contents not set'
			elementType = @_getAndCheckElementType()
			@_checkSource elementType
			@_checkPartsNames()
			@_checkDependencies()

		_getAndCheckElementType: ->
			elementTypes = (elementPart for elementPart of @elementDescription when elementPart in @_getAllowedTypes())
	
			@_assertElement elementTypes.length > 0, "has no type"
			@_assertElement elementTypes.length == 1, "has several types: #{elementTypes.join ', '}"
	
			return elementTypes[0]
	
		_checkSource: (elementType) ->
			source = @elementDescription[elementType]

			#TODO: исправить сообщение
			@_assertElement source, "part '#{elementType}' should have value"
	
			if elementType in [@_keySourceFactoryFunction, @_keySourceSingle]
				@_assertElement typeof source == 'function', "part '#{elementType}' should be function"
	
		_assertElement: (condition, message) -> assert condition, "invalid element '#{@elementName}': " + message

		_checkPartsNames: ->
			#TODO: убрать константу 'deps'
			#TODO: проверять, что ровно одна часть создания элемента
			allAllowedParts = @_getAllowedTypes().concat 'deps'
			unknownParts = (part for part of @elementDescription when part not in allAllowedParts)
			@_assertElement unknownParts.length == 0, "unknown description parts: #{unknownParts.join ', '}. allowed parts: #{allAllowedParts.join ', '}"

		_checkDependencies: ->
			if @_keyDependencies of @elementDescription
				dependencies = @elementDescription[@_keyDependencies]
				typeofDeps = if dependencies == null then 'null' else typeof @elementDescription.deps
				@_assertElement typeofDeps == 'object' and (dep for dep of dependencies).length > 0, "deps should be non-empty dictionary, #{typeofDeps} given"

				for depName, depValue of dependencies
					@_assertElement typeof depValue == 'string', "dependency '#{depName}' should be a string"
					@_assertElement depValue in @schema, "dependency '#{depName}': schema doesn't have element '#{depValue}'"
