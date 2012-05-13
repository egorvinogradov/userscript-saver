class TaistieList extends Spine.Controller
	elements:
		".taisties__list-own": "items"
	events:
		"click .taisties__create": "create"

	constructor: (element, url, taistieCollection)->
		@_taistieCollection = taistieCollection
		super el: element
		@_url = url
		@_taistieCollection.bind("refresh", @addAll)
		@_taistieCollection.fetch()

	addOne: (taistie) =>
		view = new TaistieView(item: taistie)
		@items.append(view.render().el)
		view

	addAll: =>
		@_taistieCollection.getTaistiesForUrl @_url, (taisties) ->
			@addOne taistie for taistie in taisties

	create: =>
		newTaistie = @_taistieCollection.create
				name: ""
				active: false

		newView = @addOne newTaistie
		newView.startEditing()
