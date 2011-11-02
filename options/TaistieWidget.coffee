class TaistieWidget extends SingleItemController
	domClass: '.item'

	getChildELementDescriptions: ->
		".viewName":
			modelAttribute: "name"
		".inputName":
			modelAttribute: "name"
		".inputActive":
			modelAttribute: "active"
		".inputJs":
			modelAttribute: "js"
		".inputUrlRegexp":
			modelAttribute: "urlRegexp"
		".inputCss":
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
