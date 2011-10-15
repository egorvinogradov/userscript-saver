class TaistieWidget extends Spine.Controller
	events:
		"change   input[type=checkbox]": "toggle"
		"click    .destroy":             "remove"
		"dblclick .view":                "startEditing"
		"keypress input[type=text]":     "blurOnEnter"
		"blur     input[type=text]":     "finishEditing"

	elements:
		".view": "view"
		".edit": "edit"
		"input[type=text]": "input"

	constructor: ->
		super
		@item.bind "update",  @render
		@item.bind "destroy", @destroy

	render: =>
		@replace $("#taskTemplate").tmpl @item
		@

	toggle: ->
		@item.active = !@item.active
		@item.save()

	destroy: =>
		@el.remove()

	remove: -> @item.destroy()

	startEditing: ->
		@edit.show()
		@view.hide()
		@input.focus()

	blurOnEnter: (e) -> if e.keyCode is 13 then e.target.blur()

	finishEditing: ->
		@view.show()
		@edit.hide()
		@item.updateAttributes name: @input.val()
