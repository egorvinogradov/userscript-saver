class TaistieListWidget extends Controller

	getChildELementDescriptions: ->
		".clear":
			events:
				click: @clear
		".items":     null
		".clear":     null
		"form":
			events:
				submit: @create
		"form input": null

	onrendered: ->
		#TODO: insert Taistie as dependency
		@_taistieRepository.bind "create", @addOne
		@_taistieRepository.bind "refresh", @addAll
		@_taistieRepository.fetch()

	addOne: (taistie) =>
		view = @_newTaistieWidget()
		view.setModel taistie
		view._templateAccessor =
			#todo: 1) di + class, 2) внутри templates не использовать класс template?
			getDomFromTemplateByClass: (templateClass) -> $("#{templateClass}.template").clone().removeClass('template')
		view.render()
		@_childElementsBySelectors['.items'].getDomAccessor().append view.getDomAccessor()

	addAll: =>
		@_taistieRepository.each @addOne

	create: =>
		#TODO: сделать отдельную модель - createdTaistie, проксирующую создание Taistie, и виджет формы
		#TODO: get child elements by @children instead of @_childElementsBySelectors
		nameInput = @_childElementsBySelectors['form input']
		@_taistieRepository.create
			name: nameInput.getValue()
			active: true
		nameInput.setValue ""

	clear: =>
		@_taistieRepository.destroyDone()
