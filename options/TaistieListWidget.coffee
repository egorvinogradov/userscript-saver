class TaistieListWidget extends Controller

	getChildELementDescriptions: ->
		".clear":
			events:
				click: => @clear
		".items":     null
		".clear":     null
		"form input": null

	#TODO: сделать обработку submit в PlainDomControl и включить это событие
	events:
		"submit form":   "create"

	onrendered: ->
		Taistie.bind "create", @addOne
		Taistie.bind "refresh", @addAll
		Taistie.fetch()

	addOne: (taistie) =>
		view = @_newTaistieWidget()
		view.setModel taistie
		view._templateAccessor =
			#todo: 1) di + class, 2) внутри templates не использовать класс template?
			getDomFromTemplateByClass: (templateClass) -> $("#{templateClass}.template").clone().removeClass('template')
		view.render()
		@_childElementsBySelectors['.items'].getDomAccessor().append view.getDomAccessor()

	#TODO: написать в Coffeescript: должен привязывать динамически, не разыменовывая конкретную функцию
	#иначе глючит, если переопределять методы прототипа после создания объекта - методы созданного объекта не изменятся
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
