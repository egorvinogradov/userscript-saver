$ = jQuery

class Taistie extends Spine.Model
	@configure "Taistie", "name", "done"

	@extend Spine.Model.Local

	@active: ->
		@select (item) -> !item.done

	@done: ->
		@select (item) -> !!item.done

	@destroyDone: ->
		rec.destroy() for rec in @done()

	setTaistieData: (taistieData) ->
		#TODO: написать спеки
		assert taistieData?, 'taistie data should be given'
		assert taistieData.urlRegexp?, 'url regexp shoul be given'

		@_urlRegexp = taistieData.urlRegexp
		@_js = taistieData.js ? ''
		@_css = taistieData.css ? ''
		#TODO: проверять, что имя задано
		@_name = taistieData.name
		@_active = taistieData.active

	fitsUrl: (url) ->
		urlRegexp = new RegExp(@_urlRegexp, 'g')
		return urlRegexp.test(url)

	getCss: () ->
		@_css

	getJs: () ->
		if @_js is '' then '' else '(function(){' + @_js + '})();'

	getName: () ->
		@_name

	isActive: () ->
		@_active

class Taisties extends Spine.Controller
	events:
	 "change	 input[type=checkbox]": "toggle"
	 "click		.destroy":						 "remove"
	 "dblclick .view":								"edit"
	 "keypress input[type=text]":		 "blurOnEnter"
	 "blur		 input[type=text]":		 "close"

	elements:
		"input[type=text]": "input"

	constructor: ->
		super
		@item.bind("update",	@render)
		@item.bind("destroy", @release)

	render: =>
		@replace($("#taskTemplate").tmpl(@item))
		@

	toggle: ->
		@item.done = !@item.done
		@item.save()

	remove: ->
		@item.destroy()

	edit: ->
		@el.addClass("editing")
		@input.focus()

	blurOnEnter: (e) ->
		if e.keyCode is 13 then e.target.blur()

	close: ->
		@el.removeClass("editing")
		@item.updateAttributes({name: @input.val()})

class TaskApp extends Spine.Controller
	events:
		"submit form":	 "create"
		"click	.clear": "clear"

	elements:
		".items":		 "items"
		".countVal":	"count"
		".clear":		 "clear"
		"form input": "input"

	constructor: ->
		super
		Taistie.bind("create",	@addOne)
		Taistie.bind("refresh", @addAll)
		Taistie.bind("refresh change", @renderCount)
		Taistie.fetch()

	addOne: (task) =>
		view = new Taisties(item: task)
		@items.append(view.render().el)

	addAll: =>
		Taistie.each(@addOne)

	create: (e) ->
		e.preventDefault()
		Taistie.create(name: @input.val())
		@input.val("")

	clear: ->
		Taistie.destroyDone()

	renderCount: =>
		active = Taistie.active().length
		@count.text(active)

		inactive = Taistie.done().length
		if inactive
			@clear.show()
		else
			@clear.hide()

$ ->
	new TaskApp(el: $("#tasks"))
