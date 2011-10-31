class IocContainer
	constructor: -> @_createdElements = {}
	
	setSchema: (schema) ->
		@_schema = schema
	
	getElement: (elementName) ->
		previouslyCreatedElement = @_createdElements[elementName]
		return previouslyCreatedElement ? @_getNewElement elementName

	_getNewElement: (elementName) ->
		elementDescriptor = @_getElementDescriptor elementName

		element = @_createElement elementDescriptor

		deps = elementDescriptor.deps
		if deps?
			for dependencyName, dependency of deps
				element[dependencyName] = @getElement dependency

		@_createdElements[elementName] = element
		return element

	_getElementDescriptor: (elementName) ->
		assert(@_schema?, 'Dependency schema is not set')
		elementDescriptor = @_schema[elementName]

		assert(elementDescriptor?, 'Element \'' + elementName + '\' not found in dependency schema')

		return elementDescriptor

	_createElement: (elementDescriptor) ->
		#TODO: проверять, что задан только один вариант создания элемента (при начальной установке схемы)
		if elementDescriptor.singleton?
			return @_createFromConstructor elementDescriptor.singleton

		if elementDescriptor.ref?
			return elementDescriptor.ref

	_createFromConstructor: (ctor) ->
		return new ctor
