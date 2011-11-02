class SingleItemController extends Controller
	setModel: (model) ->
		assert model?.bind?, 'model should exist and have method \'bind\''
		@_model = model
		@_model.bind "update",  @_redraw
		@_model.bind "destroy", @_destroy

	getModel: -> @_model

	_additionalInitChildControl: (childControl, controlDescription) ->
		@_bindControlToModelAtribute childControl, controlDescription.modelAttribute

	_innerRedraw: ->
		if @_model?
			for selector, elementDescription of @getChildELementDescriptions()
				do (selector, elementDescription) =>
					if elementDescription?.modelAttribute?
						control = @_childElementsBySelectors[selector]
						newValue = @_model[elementDescription.modelAttribute]
						control.setValue newValue

	_bindControlToModelAtribute: (control, modelAttribute) ->
		if modelAttribute?
			control.setValueChangeListener (newValue) =>
				@_model.updateAttribute modelAttribute, newValue

	_destroy: =>
		if @_rendered
			@_localDomAccessor.remove()
