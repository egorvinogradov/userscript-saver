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
		if not @prerendered
			@prerendered = true
			@replace $("#taskTemplate").tmpl @item
			updateVal = (domElem, propertyName) =>
				elem = $(domElem)
				value = if elem.attr('type') is 'checkbox' then elem.is(':checked') else elem.val()
				@item.updateAttribute propertyName, value

			for selector, propertyName of @newElements
				do (selector, propertyName) =>
					@$(selector).change ->
						updateVal(this, propertyName)

		activeModifier = if not @item.active then 'addClass' else 'removeClass'
		@el[activeModifier] 'inactive'

		@
	destroy: =>
		@el.remove()

	remove: -> @item.destroy()

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
