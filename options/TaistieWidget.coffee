class TaistieWidget extends Spine.Controller
	events:
		"change   input[type=checkbox]": "toggle"
		"click    .destroy":             "remove"
		"dblclick .view":                "startEditing"
		"keypress input[type=text]":     "blurOnEnter"
		"blur     input[type=text]":     "finishEditing"

	elements:
		".view": "viewDiv"
		".edit": "editDiv"
		"input[type=text]": "inputTaistieName"

	constructor: ->
		super
		@item.bind "update",  @render
		@item.bind "destroy", @destroy

	render: =>
		@replace $("#taskTemplate").tmpl @item
		@

	toggle: ->
		@item.updateAttributes active: !@item.active

	destroy: =>
		@el.remove()

	remove: -> @item.destroy()

	startEditing: ->
		@toggleEditing on
		@inputTaistieName.focus()

	blurOnEnter: (e) -> if e.keyCode is 13 then e.target.blur()

	finishEditing: ->
		@toggleEditing off
		@item.updateAttributes name: @inputTaistieName.val()

	toggleEditing: (editing)->
#		(if editing then @editDiv else @viewDiv).show()
#		(if editing then @viewDiv else @editDiv).hide()
		[activeDiv, inactiveDiv] = if editing then [@editDiv, @viewDiv] else [@viewDiv, @editDiv]
		activeDiv.show()
		inactiveDiv.hide()
