class IocContainerBare
	constructor: -> @_instanceCache = {}

	setSchema: (schema) ->
		@_schema = schema

	getInstance: (instanceName) ->
		instanceDescriptor = @_getInstanceDescriptor instanceName

		return (@_getCachedInstance instanceDescriptor) ? @_getNewInstance instanceDescriptor

	_getCachedInstance: (instanceDescriptor) ->
		if (@_canInstanceBeCached instanceDescriptor) then @_instanceCache[instanceDescriptor.name] else null

	_cacheInstance: (instanceDescriptor, instance) ->
		if @_canInstanceBeCached instanceDescriptor
			@_instanceCache[instanceDescriptor.name] = instance

	_getNewInstance: (instanceDescriptor) ->
		instance = @_createInstance instanceDescriptor
		@_addDependencies instance, instanceDescriptor.deps
		@_cacheInstance instanceDescriptor, instance

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

		#TODO: убрать magic values, переименовать single в sole
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

	#TODO: убрать magic value
	#TODO: реализовать вариант multiple
	_canInstanceBeCached: (instanceDescriptor) -> instanceDescriptor.type != 'muptiple'

	_allowedTypes: ['single', 'ref', 'factoryFunction']

	_getInstanceType: (rawInstanceData) ->
		instanceType = null
		for allowedType in @_allowedTypes
			if rawInstanceData[allowedType]?
				instanceType = allowedType
		return instanceType
