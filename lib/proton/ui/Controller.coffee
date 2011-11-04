class Controller
	constructor: ->
		@_rendered = false

	render: ->
		@_initDOM()
		@_initChildElements()

		#TODO: вызывать из виджета - должен ли быть всегда в виджете?
		#TODO: переименовать в onRendered
		@onrendered?()

	_initDOM: ->
		@_localDomAccessor = @_templateAccessor.getDomFromTemplateByClass @domClass

	getDomAccessor: -> @_localDomAccessor

	getChildDomAccessorByAlias: (alias) ->
		childElement = null
		assert alias, 'alias should be valid'

		for selector, description of @getChildELementDescriptions()
			if description?.alias == alias
				childElement = @_childElementsBySelectors[selector]

		#TODO: проверять: алиас должен быть уникальным
		assert childElement?, 'alias should exist'
		return childElement.getDomAccessor()

	_initChildElements: ->
		@_childElementsBySelectors = {}
		for selector, elementDescription of @getChildELementDescriptions()
			do (selector, elementDescription) =>
				elementDescription ?= {}

				childControl = @_createChildControl selector
				@_childElementsBySelectors[selector] = childControl

				#TODO: DI (вместо _newPlainDomControl возвращать готовый объект)
				#TODO: спек: проверять, что дочерним элементам полностью передаются опции
				singleValueController = new SingleValueController childControl
				singleValueController.init elementDescription

	_createChildControl: (selector) ->
		plainDomControl = @_newPlainDomControl()
		#TODO: использовать кастомный find вместо jquery.find - с проверкой существования
		plainDomControl.setDomAccessor @_localDomAccessor.find selector
		return plainDomControl
