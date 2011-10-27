class TaistieListWidget extends Spine.Controller
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
		Taistie.bind "create",  @addOne
		Taistie.bind "refresh", @addAll
		Taistie.bind "refresh change", @renderCount
		Taistie.fetch()

	addOne: (taistie) =>
		view = new TaistieWidget
		view.domClass = '.item'
		view.setModel taistie
		view._templateAccessor =
			getTemplateByClass: (templateClass) -> $("#{@_domClass}.template").clone().removeClass('template')

		view.setParentElement @items

	addAll: =>
	   	Taistie.each @addOne

	create: (e) ->
		e.preventDefault()
		Taistie.create
			name: @input.val()
			active: true
		@input.val ""

	clear: ->
	    Taistie.destroyDone()

	renderCount: =>
		activeCount = Taistie.active().length
		@count.text(activeCount)

		existInactiveTaisties = Taistie.inactive().length
		if existInactiveTaisties
			@clear.show()
		else @clear.hide()
