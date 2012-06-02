class IocContainerBare
	constructor: -> @_createdInstances = {}

	setSchema: (schema) ->
		@_schema = schema

	getInstance: (instanceName) ->
		instanceDescriptor = @_getInstanceDescriptor instanceName
		isCached = @_isCachedInstance instanceDescriptor
		instance = null

		if isCached
			instance = @_createdInstances[instanceName]

		if not instance
			instance = @_getNewInstance instanceDescriptor
			if isCached
				@_createdInstances[instanceName] = instance

		return instance

	_getNewInstance: (instanceDescriptor) ->
		instance = @_createInstance instanceDescriptor
		@_addDependencies instance, instanceDescriptor.deps

		return instance

	_getInstanceDescriptor: (instanceName) ->
		rawInstanceData = @_schema[instanceName]

		instanceDescriptor =
			deps: rawInstanceData.deps
			name: instanceName

		instanceDescriptor.type = @_getInstanceType rawInstanceData

		#in dependency schema, type/source are given as key/value pair
		instanceDescriptor.source = rawInstanceData[instanceDescriptor.type]

		return instanceDescriptor

	_createInstance: (instanceDescriptor) ->
		type = instanceDescriptor.type
		source = instanceDescriptor.source

		if type == 'single'
			return @_createFromConstructor source

		if type == 'ref'
			return source

		if type == 'factoryFunction'
			return =>
				assert arguments.length == 0, "factoryFunction '#{instanceDescriptor.name}' should be called without arguments"
				newInstance = new source
				@_addDependencies newInstance, instanceDescriptor.deps
				return newInstance

	_addDependencies: (instance, dependencies) ->
		if dependencies
			for depName, dependency of dependencies
				instance[depName] = @getInstance dependency

	_createFromConstructor: (ctor) ->
		return new ctor

	_isCachedInstance: (instanceDescriptor) -> instanceDescriptor.type != 'prototype'

	_allowedTypes: ['single', 'ref', 'factoryFunction']

	_getInstanceType: (rawInstanceData) ->
		instanceType = null
		for allowedType in @_allowedTypes
			if rawInstanceData[allowedType]?
				instanceType = allowedType
		return instanceType
