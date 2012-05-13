class TaistieList extends Spine.Controller
	elements:
		".taisties__list-own": "own"
		".taisties__list-recommended": "recommended"
	events:
		"click .taisties__create": "create"

	constructor: (element, url, taistieCollection)->
		@_taistieCollection = taistieCollection
		super el: element
		@_url = url
		@_taistieCollection.bind("refresh", @addAll)
		@_taistieCollection.fetch()

	addOne: (taistie) =>
		taistie.description = if taistie.description and taistie.description.length > 100
			taistie.description.substr(0, 100) + "..."
		
		list = if taistie.isOwnTaistie() then @own else @recommended
		view = new TaistieView(item: taistie)
		list.append(view.render().el)
		view

	addAll: =>
		@addOne taistie for taistie in @_taistieCollection.getTaistiesForUrl(@_url)

	create: =>
		newTaistie = @_taistieCollection.create
				name: ""
				active: false

		newView = @addOne newTaistie
		newView.startEditing()

