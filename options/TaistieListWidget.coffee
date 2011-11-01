class TaistieListWidget extends Spine.Controller
	events:
		"submit form":   "create"
		"click  .clear": "clear"

	elements:
		".items":     "items"
		".countVal":  "count"
		".clear":     "clear"
		"form input": "input"

	start: ->
		Taistie.bind "create",  @addOne
		Taistie.bind "refresh", @addAll
		Taistie.bind "refresh change", @renderCount
		Taistie.fetch()

	addOne: (taistie) =>
		view = @_newtaistieWidget()
		view.setModel taistie
		view._newPlainDomControl = -> new PlainDomControl
		view._templateAccessor =
			getDomFromTemplateByClass: (templateClass) -> $("#{templateClass}.template").clone().removeClass('template')
		view.render()
		@items.append view.getDomAccessor()

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
