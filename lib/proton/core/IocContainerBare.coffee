class IocContainerBare
	#TODO: добавить constructor injection и по максимуму заменить везде на него setter injection
	constructor: -> @_createdElements = {}

	setSchema: (schema) ->
		assert schema?, 'Dependency schema should be given'
		assert (element for element of schema).length > 0, 'Dependency schema should be non-empty'

		allElementNames = (elName for elName of schema)
		@_checkSchemaElement elementName, elementDescription, allElementNames for elementName, elementDescription of schema
		@_schema = schema

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

	getElement: (elementName) ->
		elementDescriptor = @_getElementDescriptor elementName
		isCached = @_isCachedElement elementDescriptor
		element = null

		if isCached
			element = @_createdElements[elementName]

		if not element?
			element = @_getNewElement elementDescriptor
			if isCached
				@_createdElements[elementName] = element

		return element

	_getNewElement: (elementDescriptor) ->
		element = @_createElement elementDescriptor
		@_addDependencies element, elementDescriptor.deps

		return element

	_getElementDescriptor: (elementName) ->
		assert(@_schema?, 'Dependency schema is not set')
		rawElementData = @_schema[elementName]
		assert(rawElementData?, 'Element \'' + elementName + '\' not found in dependency schema')

		elementDescriptor =
			deps: rawElementData.deps
			name: elementName

		elementDescriptor.type = @_getElementType rawElementData

		#in dependency schema, type/source are given as key/value pair
		elementDescriptor.source = rawElementData[elementDescriptor.type]

		return elementDescriptor

	_createElement: (elementDescriptor) ->
		type = elementDescriptor.type
		source = elementDescriptor.source

		if type == 'single'
			return @_createFromConstructor source

		if type == 'ref'
			return source

		if type == 'factoryFunction'
			return =>
				assert arguments.length == 0, "factoryFunction '#{elementDescriptor.name}' should be called without arguments"
				newElement = new source
				@_addDependencies newElement, elementDescriptor.deps
				return newElement

	_addDependencies: (element, dependencies) ->
		if dependencies
			for depName, dependency of dependencies
				element[depName] = @getElement dependency

	_createFromConstructor: (ctor) ->
		return new ctor

	_isCachedElement: (elementDescriptor) -> elementDescriptor.type != 'prototype'

	_allowedTypes: ['single', 'ref', 'factoryFunction']

	_getElementType: (rawElementData) ->
		elementType = null
		for allowedType in @_allowedTypes
			if rawElementData[allowedType]?
				elementType = allowedType
		return elementType
