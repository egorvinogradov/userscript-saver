$ = jQuery

class Taisties extends Spine.Controller
	events:
	 "change	 input[type=checkbox]": "toggle"
	 "click		.destroy":						 "remove"

	elements:

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
	events:

	elements:
		".items":		 "items"

	constructor: ->
		super
		Taistie.bind("refresh", @addAll)
		Taistie.fetch()

	addOne: (task) =>
		view = new Taisties(item: task)
		@items.append(view.render().el)

	addAll: =>
		Taistie.each(@addOne)

$ ->
	new TaskApp(el: $("#tasks"))
