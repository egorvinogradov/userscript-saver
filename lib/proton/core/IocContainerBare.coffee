class IocContainerBare
	constructor: -> @_instanceCache = {}

	setSchema: (schema) ->
		@_schema = schema

	getInstance: (instanceName) ->
		descriptor = @_getInstanceDescriptor instanceName

		return (@_getCachedInstance descriptor) ? @_getNewInstance descriptor

	_getCachedInstance: (descriptor) ->
		if (@_canInstanceBeCached descriptor) then @_instanceCache[descriptor.name] else null

	_cacheInstance: (descriptor, instance) ->
		if @_canInstanceBeCached descriptor
			@_instanceCache[descriptor.name] = instance

	_getNewInstance: (descriptor) ->
		instance = @_createInstance descriptor
		@_addDependencies instance, descriptor.deps
		@_cacheInstance descriptor, instance

		return instance

	_getInstanceDescriptor: (instanceName) ->
		rawInstanceData = @_schema[instanceName]

		descriptor =
			deps: rawInstanceData.deps
			name: instanceName

		descriptor.type = @_getInstanceType rawInstanceData

		#in dependency schema, type/source are given as key/value pair
		descriptor.source = rawInstanceData[descriptor.type]

		return descriptor

	_createInstance: (descriptor) ->
		type = descriptor.type
		source = descriptor.source

		#TODO: убрать magic values, переименовать single в sole
		if type == 'single'
			return @_createFromConstructor source

		if type == 'ref'
			return source

		if type == 'factoryFunction'
			return =>
				assert arguments.length == 0, "factoryFunction '#{descriptor.name}' should be called without arguments"
				newInstance = new source
				@_addDependencies newInstance, descriptor.deps
				return newInstance

	_addDependencies: (instance, dependencies) ->
		if dependencies
			for depName, dependency of dependencies
				instance[depName] = @getInstance dependency

	_createFromConstructor: (ctor) ->
		return new ctor

	#TODO: убрать magic value
	#TODO: реализовать вариант multiple
	_canInstanceBeCached: (descriptor) -> descriptor.type != 'muptiple'

	_allowedTypes: ['single', 'ref', 'factoryFunction']

	_getInstanceType: (rawInstanceData) ->
		instanceType = null
		for allowedType in @_allowedTypes
			if rawInstanceData[allowedType]?
				instanceType = allowedType
		return instanceType
