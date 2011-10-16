class TaistieWidget extends Spine.Controller
	events:
		"click    .destroy":             "remove"
		"dblclick .view":                "startEditing"
		"click .saveTaistie": "finishEditing"

	elements:
		".view": "viewDiv"
		".edit": "editDiv"
		".inputName": "inputName"

	newElements:
		".inputActive": "active"
		".inputJs": "js"
		".inputUrlRegexp": "urlRegexp"
		".inputCss": "css"

	constructor: ->
		super
		@item.bind "update",  @render
		@item.bind "destroy", @destroy

	render: =>
		if not @rendered
			@rendered = true
			@replace $("#taskTemplate").tmpl @item
			updateVal = (domElem, propertyName) =>
				elem = $(domElem)
				value = if elem.attr('type') is 'checkbox' then elem.is(':checked') else elem.val()
				console.log propertyName, value, elem
				@item.updateAttribute propertyName, value

			for selector, propertyName of @newElements
				do (selector, propertyName) =>
					@$(selector).change ->
						updateVal(this, propertyName)
		@
	destroy: =>
		@el.remove()

	remove: -> @item.destroy()

	startEditing: ->
		@toggleEditing on
		@inputName.focus()

	finishEditing: ->
		@toggleEditing off

	toggleEditing: (editing)->
		[activeDiv, inactiveDiv] = if editing then [@editDiv, @viewDiv] else [@viewDiv, @editDiv]
		activeDiv.show()
		inactiveDiv.hide()
