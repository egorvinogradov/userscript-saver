class TaistieList extends Spine.Controller
	elements:
		".items":		 "items"
	events:
		"click .create": "create"

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
			name: "<new taistie>"
			active: true

		newView = @addOne newTaistie
		newView.startEditing()
