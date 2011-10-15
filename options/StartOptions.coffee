$ = jQuery

class Task extends Spine.Model
	@configure "Task", "name", "active"

	@extend Spine.Model.Local

	@active: -> @select (item) -> item.active

	@inactive: -> @select (item) -> !item.active

	@destroyDone: -> rec.destroy() for rec in @inactive()

class Tasks extends Spine.Controller
	events:
		"change   input[type=checkbox]": "toggle"
		"click    .destroy":             "remove"
		"dblclick .view":                "edit"
		"keypress input[type=text]":     "blurOnEnter"
		"blur     input[type=text]":     "close"

	elements:
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

	edit: ->
		@el.addClass "editing"
		@input.focus()

	blurOnEnter: (e) -> if e.keyCode is 13 then e.target.blur()

	close: ->
		@el.removeClass "editing"
		@item.updateAttributes name: @input.val()

class TaskApp extends Spine.Controller
	events:
		"submit form":   "create"
		"click  .clear": "clear"

	elements:
		".items":     "items"
		".countVal":  "count"
		".clear":     "clear"
		"form input": "input"

	constructor: ->
		super
		Task.bind "create",  @addOne
		Task.bind "refresh", @addAll
		Task.bind "refresh change", @renderCount
		Task.fetch()

	addOne: (task) =>
		view = new Tasks item: task
		@items.append view.render().el

	addAll: =>
	   	Task.each @addOne

	create: (e) ->
		e.preventDefault()
		Task.create
			name: @input.val()
			active: true
		@input.val ""

	clear: ->
	    Task.destroyDone()

	renderCount: =>
		active = Task.active().length
		@count.text(active)

		inactive = Task.inactive().length
		if inactive
			@clear.show()
		else @clear.hide()

$ -> new TaskApp el: $("#tasks")