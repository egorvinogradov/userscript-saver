class IocContainerBare
	constructor: -> @_instanceCache = {}

	setSchema: (schema) ->
		@_schema = schema

	getInstance: (instanceName) ->
		descriptor = @_getInstanceDescriptor instanceName

		return (@_getCachedInstance instanceName) ? @_getNewInstance descriptor

	_getCachedInstance: (instanceName) ->
		if (@_canInstanceBeCached instanceName) then @_instanceCache[instanceName] else null

	_cacheInstance: (instanceName, instance) ->
		if @_canInstanceBeCached instanceName
			@_instanceCache[instanceName] = instance

	_getNewInstance: (descriptor) ->
		instance = @_createInstance descriptor
		@_addDependencies descriptor.name, instance
		@_cacheInstance descriptor.name, instance

		return instance

	_getInstanceDescriptor: (instanceName) ->
		rawInstanceData = @_schema[instanceName]

		descriptor =
			deps: rawInstanceData.deps
			name: instanceName

		descriptor.type = @_getInstanceType instanceName

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
				@_addDependencies descriptor.name, newInstance
				return newInstance

	_addDependencies: (instanceName, instance) ->
		#TODO: remove magic value 'deps'
		dependencies = (@_getInstanceData instanceName).deps
		console.log instanceName, dependencies
		if dependencies
			for depName, dependency of dependencies
				instance[depName] = @getInstance dependency

	_createFromConstructor: (ctor) ->
		return new ctor

	#TODO: убрать magic value
	#TODO: реализовать вариант multiple
	_canInstanceBeCached: (instanceName) -> (@_getInstanceType instanceName) != 'muptiple'

	_allowedTypes: ['single', 'ref', 'factoryFunction']

	_getInstanceType: (instanceName) ->
		for allowedType in @_allowedTypes
			if (@_getInstanceData instanceName)[allowedType]?
				return allowedType

	_getInstanceData: (instanceName) -> @_schema[instanceName]
