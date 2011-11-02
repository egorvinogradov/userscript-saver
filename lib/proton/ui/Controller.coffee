class Controller
	constructor: ->
		@_rendered = false

	render: ->
		if not @_rendered
			@_initDOM()
			@_initChildElements()
			@_rendered = true

		#TODO: должно вызываться только при событии модели - мб вместо этого вызывать model.refresh()?
		@_redraw()

	_initDOM: ->
		@_localDomAccessor = @_templateAccessor.getDomFromTemplateByClass @domClass

	getDomAccessor: ->
		assert @_rendered, 'should be rendered before using @getDomAccessor'
		return @_localDomAccessor

	getChildDomAccessorByAlias: (alias) ->
		childElement = null
		assert alias, 'alias should be valid'

		for selector, description of @childELementDescriptions
			if description?.alias == alias
				childElement = @_childElementsBySelectors[selector]

		#TODO: проверять: алиас должен быть уникальным
		assert childElement?, 'alias should exist'
		return childElement.getDomAccessor()

	_initChildElements: ->
		@_childElementsBySelectors = {}
		for selector, elementDescription of @childELementDescriptions
			do (selector, elementDescription) =>
				elementDescription ?= {}

				childControl = @_createChildControl selector
				@_childElementsBySelectors[selector] = childControl
				@_listenToControlEvents childControl, elementDescription.events
				@_additionalInitChildControl? childControl, elementDescription

	_createChildControl: (selector) ->
		plainDomControl = @_newPlainDomControl()
		#TODO: использовать кастомный find вместо jquery.find - с проверкой существования
		plainDomControl.setDomAccessor @_localDomAccessor.find selector
		return plainDomControl

	_listenToControlEvents: (control, events) ->
		if events?
			for eventName, eventHandler of events

				#TODO: вынести в проверку схемы при рендере
				assert typeof eventHandler == 'function', 'invalid handler for event #{eventName}'
				do(eventName, eventHandler) =>
					control.subscribeToEvent eventName, => eventHandler.apply @

	#TODO: вынести в SingleItemController
	_redraw: =>
		@_innerRedraw?()
		@customRedraw?()
