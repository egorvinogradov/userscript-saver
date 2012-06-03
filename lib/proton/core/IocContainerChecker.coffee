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

	_getChecks: -> {@setSchema, @getInstance}

	setSchema: (iocContainer, schema) ->
		assert schema?, 'Dependency schema should be given'
		instanceNames = (instanceName for instanceName, instanceDescription of schema)
		assert instanceNames.length > 0, 'Dependency schema should be non-empty'

		(new _schemaInstanceChecker instanceName, schema).check() for instanceName in instanceNames

	getInstance: (iocContainer, instanceName) ->
		assert iocContainer._schema?, 'Dependency schema is not set'
		rawInstanceData = iocContainer._schema[instanceName]
		assert rawInstanceData?, 'Instance \'' + instanceName + '\' not found in dependency schema'

	class _schemaInstanceChecker
		constructor: (@instanceName, @schema) ->
			@instanceDescription = @schema[@instanceName]

		_keySourceSingle: 'single'
		_keySourceReference: 'ref'
		_keySourceFactoryFunction: 'factoryFunction'
		_keyDependencies: 'deps'

		_getAllowedTypes: -> [@_keySourceSingle, @_keySourceReference, @_keySourceFactoryFunction]

		check: ->
			@_assertInstance @instanceDescription?, 'contents not set'
			instanceType = @_getAndCheckInstanceType()
			@_checkSource instanceType
			@_checkPartsNames()
			@_checkDependencies()

		_getAndCheckInstanceType: ->
			instanceTypes = (instancePart for instancePart of @instanceDescription when instancePart in @_getAllowedTypes())
	
			@_assertInstance instanceTypes.length > 0, "has no type"
			@_assertInstance instanceTypes.length == 1, "has several types: #{instanceTypes.join ', '}"
	
			return instanceTypes[0]
	
		_checkSource: (instanceType) ->
			source = @instanceDescription[instanceType]

			#TODO: исправить сообщение
			@_assertInstance source, "part '#{instanceType}' should have value"
	
			if instanceType in [@_keySourceFactoryFunction, @_keySourceSingle]
				@_assertInstance typeof source == 'function', "part '#{instanceType}' should be function"
	
		_assertInstance: (condition, message) -> assert condition, "invalid instance '#{@instanceName}': " + message

		_checkPartsNames: ->
			allAllowedParts = @_getAllowedTypes().concat @_keyDependencies
			unknownParts = (part for part of @instanceDescription when part not in allAllowedParts)
			@_assertInstance unknownParts.length == 0, "unknown description parts: #{unknownParts.join ', '}. allowed parts: #{allAllowedParts.join ', '}"

		_checkDependencies: ->
			if @_keyDependencies of @instanceDescription
				dependencies = @instanceDescription[@_keyDependencies]
				typeofDeps = if dependencies == null then 'null' else typeof @instanceDescription.deps
				@_assertInstance typeofDeps == 'object' and (dep for dep of dependencies).length > 0, "deps should be non-empty dictionary, #{typeofDeps} given"

				for depName, depValue of dependencies
					@_assertInstance typeof depValue == 'string', "dependency '#{depName}' should be a string"
					@_assertInstance depValue in @schema, "dependency '#{depName}': schema doesn't have instance '#{depValue}'"
