class TaistieView extends Spine.Controller
	events:
		"change	 input[type=checkbox]": "toggle"
		"click		.destroy": "remove"
		"click .save": "finishEditing"
		"click .editbutton": "startEditing"

	elements:
		".nameInput": "nameInput"
		".rootUrlInput": "rootUrlInput"
		".cssInput": "cssInput"
		".jsInput": "jsInput"

	constructor: ->
		super
		@item.bind("update",	@render)
		@item.bind("destroy", @release)

	render: =>
		@replace($("#taskTemplate").tmpl(@item))
		@

	toggle: ->
		@item.active = !@item.active
		@item.save()

	remove: ->
		@item.destroy()

	startEditing: ->
		@el.addClass "editing"
		@nameInput.focus()

	finishEditing: ->
		@el.removeClass "editing"
		@item.updateAttributes
			name: @nameInput.val()
			rootUrl: @rootUrlInput.val()
			css: @cssInput.val()
			js: @jsInput.val()
