class TaistieWidget extends SingleItemController
	domClass: '.item'

	getChildELementDescriptions: ->
		".viewName":
			model: @_model
			modelAttribute: "name"
		".inputName":
			model: @_model
			modelAttribute: "name"
		".inputActive":
			model: @_model
			modelAttribute: "active"
		".inputJs":
			model: @_model
			modelAttribute: "js"
		".inputUrlRegexp":
			model: @_model
			modelAttribute: "urlRegexp"
		".inputCss":
			model: @_model
			modelAttribute: "css"
		".view":
			events:
				dblclick: @startEditing
		".edit": null
		".saveTaistie":
			events:
				click: => @toggleEditing off
		".destroy":
			events:
				click: => @getModel().destroy()

	customRedraw: ->
		activeModifier = if not @getModel().active then 'addClass' else 'removeClass'
		@getDomAccessor()[activeModifier] 'inactive'
		
	startEditing: =>
		@toggleEditing on

	toggleEditing: (editing) ->
		activeDivSelector = if editing then '.edit' else '.view'
		inactiveDivSelector = if editing then '.view' else '.edit'
		activeDiv = @_childElementsBySelectors[activeDivSelector]
		inactiveDiv = @_childElementsBySelectors[inactiveDivSelector]
		activeDiv.getDomAccessor().show()
		inactiveDiv.getDomAccessor().hide()

		if editing
			@_childElementsBySelectors['.inputName'].getDomAccessor().focus()
