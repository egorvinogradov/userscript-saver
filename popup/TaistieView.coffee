class TaistieView extends Spine.Controller
	events:
		"change	.taisties__switch-checkbox": "toggle"
		"click .taisties__remove": "remove"
		"click .taisties__edit": "startEditing"
		"click .taisties__new-save": "finishEditing"
		"click .taisties__new-cancel": "cancelEditing"

	elements:
		".taisties__new-name": "nameInput"
		".taisties__new-url": "rootUrlInput"
		".taisties__new-css": "cssInput"
		".taisties__new-js": "jsInput"

	constructor: ->
		super
		@item.bind("update",	@render)
		@item.bind("destroy", @release)

	render: =>
		@replace($("#taisty").tmpl(@item))
		@

	toggle: ->
		@item.active = !@item.active
		@item.save()

	remove: ->
		@item.destroy()

	startEditing: ->
		@el.add('.taisties').addClass "m-editing"
		@nameInput.focus()

	finishEditing: ->
		@el.add('.taisties').removeClass "m-editing"
		@item.updateAttributes
			name: @nameInput.val()
			rootUrl: @rootUrlInput.val()
			css: @cssInput.val()
			js: @jsInput.val()

	cancelEditing: ->
    @el.add('.taisties').removeClass "m-editing"