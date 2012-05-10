class TaistieList extends Spine.Controller
	elements:
		".taisties__list-own": "items"
	events:
		"click .taisties__create": "create"

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
			name: ""
			active: false

		newView = @addOne newTaistie
		newView.startEditing()
