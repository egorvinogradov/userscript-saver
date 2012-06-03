class IocContainerBare
	constructor: -> @_instanceCache = {}

	setSchema: (schema) ->
		@_schema = schema

	getInstance: (instanceName) -> (@_getCachedInstance instanceName) ? @_getNewInstance instanceName

	_getCachedInstance: (instanceName) ->
		if (@_canInstanceBeCached instanceName) then @_instanceCache[instanceName] else null

	_cacheInstance: (instanceName, instance) ->
		if @_canInstanceBeCached instanceName
			@_instanceCache[instanceName] = instance

	_getNewInstance: (instanceName) ->
		instance = @_createInstance instanceName
		@_addDependencies instanceName, instance
		@_cacheInstance instanceName, instance

		return instance

	_createInstance: (instanceName) ->
		type = @_getInstanceType instanceName
		#in dependency schema, type/source are given as key/value pair
		source = (@_getInstanceData instanceName)[type]

		#TODO: убрать magic values, переименовать single в sole
		if type == 'single'
			return @_createFromConstructor source

		if type == 'ref'
			return source

		if type == 'factoryFunction'
			return =>
				#TODO: как-то убрать отсюда assert в контракт
				#вынести в метод контейнера
				assert arguments.length == 0, "factoryFunction '#{instanceName}' should be called without arguments"
				newInstance = new source
				@_addDependencies instanceName, newInstance
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
