$ = jQuery

class TaistieView extends Spine.Controller
	events:
		"change	 input[type=checkbox]": "toggle"
		"click		.destroy": "remove"
		"click .save": "finishEditing"
		"click .editbutton": "startEditing"

	elements:
		".nameInput": "nameInput"
		".urlRegexpInput": "urlRegexpInput"
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
			urlRegexp: @urlRegexpInput.val()
			css: @cssInput.val()
			js: @jsInput.val()

class TaskApp extends Spine.Controller
	elements:
		".items":		 "items"
	events:
		"click .create": "create"

	constructor: ->
		super
		Taistie.bind("refresh", @addAll)
		Taistie.fetch()

	addOne: (taistie) =>
		view = new TaistieView(item: taistie)
		@items.append(view.render().el)
		view

	addAll: =>
		Taistie.each(@addOne)

	create: =>
		newTaistie = Taistie.create
			name: "<new taistie>"
			active: true

		newView = @addOne newTaistie
		newView.startEditing()

$ ->
	new TaskApp(el: $("#tasks"))
