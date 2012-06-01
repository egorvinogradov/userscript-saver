class IocContainerBare
	constructor: -> @_createdElements = {}

	setSchema: (schema) ->
		@_schema = schema

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
		rawElementData = @_schema[elementName]

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
