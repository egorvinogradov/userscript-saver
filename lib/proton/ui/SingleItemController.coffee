class SingleItemController extends Controller
	setModel: (model) ->
		assert model?.bind?, 'model should exist and have method \'bind\''
		@_model = model
		@_model.bind "destroy", @_destroy

	getModel: -> @_model

	_destroy: =>
		if @_rendered
			@_localDomAccessor.remove()

	#TODO: create spec on it
	onrendered: ->
		@_rendered = true
		@_model.trigger 'update', @_model
