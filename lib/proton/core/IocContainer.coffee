class IocContainer
	#TODO: заменить на constructor injection
	constructor: -> @_createdElements = {}
	
	setSchema: (schema) ->
		#TODO: проверять, что в каждом элементе схемы нет ничего лишнего
		assert schema?, 'Dependency schema should be given'
		assert (element for element of schema).length > 0, 'Dependency schema should be non-empty'

		@_checkSchemaElement elementName, elementDescription for elementName, elementDescription of schema
		@_schema = schema

	_checkSchemaElement: (elementName, elementDescription) ->
		assertElement = (condition, message) ->
			assert condition, "invalid element '#{elementName}': " + message

		assertElement elementDescription?, 'contents not set'
		elementTypes = (elementPart for elementPart of elementDescription when elementPart in @_allowedTypes)
		assertElement elementTypes.length == 1, "has several types: #{elementTypes.join ', '}"

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
		#TODO: проверять, что задан только один вариант создания элемента (при начальной установке схемы)
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
			for dependencyName, dependency of dependencies
				element[dependencyName] = @getElement dependency

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
