class TaistieWidget extends Controller
	events:
		"click    .destroy":             "remove"
		"dblclick .view":                "startEditing"
		"click .saveTaistie": "finishEditing"

	elements:
		".view": "viewDiv"
		".edit": "editDiv"
		".inputName": "inputName"

	newElements:
		".viewName": "name"
		".inputName": "name"
		".inputActive": "active"
		".inputJs": "js"
		".inputUrlRegexp": "urlRegexp"
		".inputCss": "css"

	customRedraw: ->
		activeModifier = if not @getModel().active then 'addClass' else 'removeClass'
		@getDomAccessor()[activeModifier] 'inactive'

	remove: -> @getModel().destroy()

	startEditing: ->
		@toggleEditing on

	finishEditing: ->
		@toggleEditing off

	toggleEditing: (editing)->
		[activeDiv, inactiveDiv] = if editing then [@editDiv, @viewDiv] else [@viewDiv, @editDiv]
		activeDiv.show()
		inactiveDiv.hide()
		if editing
			@inputName.focus()
