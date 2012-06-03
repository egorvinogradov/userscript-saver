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
		source = @_getInstanceSource instanceName
		type = @_getInstanceType instanceName

		#TODO: убрать magic values, переименовать single в sole
		if type == 'single'
			return @_createFromConstructor source

		if type == 'ref'
			return @_useDirectReference source

		if type == 'factoryFunction'
			return @_createFactoryFunction source, instanceName

	_addDependencies: (instanceName, instance) ->
		#TODO: remove magic value 'deps'
		dependencies = (@_getInstanceData instanceName).deps

		if dependencies
			for depName, dependency of dependencies
				instance[depName] = @getInstance dependency

	_createFromConstructor: (ctor) -> new ctor

	_useDirectReference: (reference) -> reference

	_createFactoryFunction: (ctor, instanceName) ->
		=>
			#TODO: как-то убрать отсюда assert в контракт
			#вынести в метод контейнера
			assert arguments.length == 0, "factoryFunction '#{instanceName}' should be called without arguments"
			newInstance = new ctor
			@_addDependencies instanceName, newInstance
			return newInstance


	#TODO: убрать magic value
	#TODO: реализовать вариант multiple
	_canInstanceBeCached: (instanceName) -> (@_getInstanceType instanceName) != 'muptiple'

	_allowedTypes: ['single', 'ref', 'factoryFunction']

	_getInstanceType: (instanceName) ->
		for allowedType in @_allowedTypes
			if (@_getInstanceData instanceName)[allowedType]?
				return allowedType

	_getInstanceData: (instanceName) -> @_schema[instanceName]

	_getInstanceSource: (instanceName) ->
		#in dependency schema, type/source are given as key/value pair
		instanceType = @_getInstanceType instanceName
		return (@_getInstanceData instanceName)[instanceType]
