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

	initialRender: ->
		@replace $("#taskTemplate").tmpl @item
		updateVal = (domElem, propertyName) =>
			elem = $(domElem)
			value = if elem.attr('type') is 'checkbox' then elem.is(':checked') else elem.val()
			@item.updateAttribute propertyName, value

		for selector, propertyName of @newElements
			do (selector, propertyName) =>
				@$(selector).change ->
					updateVal(this, propertyName)

	refreshRender: ->
		activeModifier = if not @item.active then 'addClass' else 'removeClass'
		@el[activeModifier] 'inactive'

		for selector, propertyName of @newElements
			do (selector, propertyName) =>
				val = @item[propertyName]
				elem = @$(selector)
				if elem.attr('type') is 'checkbox' then elem.attr('checked', val)
				else if elem[0].tagName.toLowerCase() is 'input' then elem.val(val)
				else elem.text(val)

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
