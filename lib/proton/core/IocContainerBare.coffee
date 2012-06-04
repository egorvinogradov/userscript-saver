class IocContainerBare
	constructor: -> @_instanceCache = {}

	setSchema: (schema) -> @_schema = schema

	getInstance: (instanceName) -> (@_getCachedInstance instanceName) ? @_getNewInstance instanceName

	_getCachedInstance: (instanceName) ->
		if (@_canInstanceBeCached instanceName) then @_instanceCache[instanceName] else null

	_getNewInstance: (instanceName) ->
		instance = @_createInstance instanceName

		#don't set up dependencies for factoryFunction itself
		# - they will be set directly for objects created by it
		if (@_getInstanceType instanceName) != @_keySourceFactoryFunction
			@_addDependencies instanceName, instance

		@_cacheInstance instanceName, instance
		return instance

	_addDependencies: (instanceName, instance) ->
		dependencies = (@_getInstanceData instanceName)[@_keyDependencies]

		if dependencies
			for depName, dependency of dependencies
				instance[depName] = @getInstance dependency

	_cacheInstance: (instanceName, instance) ->
		if @_canInstanceBeCached instanceName
			@_instanceCache[instanceName] = instance

	_createInstance: (instanceName) ->
		instanceType = @_getInstanceType instanceName
		source = @_getInstanceSource instanceName
		switch instanceType
			when @_keySourceSingle then @_createFromConstructor source
			when @_keySourceReference then @_useDirectReference source
			when @_keySourceFactoryFunction then @_createFactoryFunction source, instanceName

	_createFromConstructor: (ctor) -> new ctor

	_useDirectReference: (reference) -> reference

	_createFactoryFunction: (ctor, instanceName) ->
		=> @_useFactoryFunction ctor, instanceName, arguments

	_useFactoryFunction: (ctor, instanceName, args) ->
		newInstance = {}
		ctor.apply newInstance, args
		@_addDependencies instanceName, newInstance
		return newInstance

	#TODO: реализовать вариант multiple
	_canInstanceBeCached: (instanceName) -> (@_getInstanceType instanceName) != @_keySourceMultiple

	_keySourceSingle: 'single'
	_keySourceReference: 'ref'
	_keySourceFactoryFunction: 'factoryFunction'
	_keySourceMultiple: 'multiple'
	_keyDependencies: 'deps'

	_getInstanceType: (instanceName) ->
		for allowedType in [@_keySourceSingle, @_keySourceReference, @_keySourceFactoryFunction, @_keySourceMultiple]
			if (@_getInstanceData instanceName)[allowedType]?
				return allowedType

	_getInstanceData: (instanceName) -> @_schema[instanceName]

	_getInstanceSource: (instanceName) ->
		#in dependency schema, type/source are given as key/value pair
		instanceType = @_getInstanceType instanceName
		return (@_getInstanceData instanceName)[instanceType]
