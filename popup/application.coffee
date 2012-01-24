$ = jQuery

class TaistieView extends Spine.Controller
	events:
		"change	 input[type=checkbox]": "toggle"
		"click		.destroy": "remove"

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

$ ->
	new TaskApp(el: $("#tasks"))
