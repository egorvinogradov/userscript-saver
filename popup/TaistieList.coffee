class TaistieList extends Spine.Controller
	elements:
		".items":		 "items"
	events:
		"click .create": "create"

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
		@addOne taistie for taistie in @_taistieCollection.getTaistiesForUrl(@_url)

	create: =>
		newTaistie = @_taistieCollection.create
			name: "<new taistie>"
			active: true

		newView = @addOne newTaistie
		newView.startEditing()
