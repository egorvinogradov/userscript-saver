class TaistieList extends Spine.Controller
	elements:
		".taisties__list-own": "own"
		".taisties__list-recommended": "recommended"
	events:
		"click .taisties__create": "create"
		"click .taisties__show-own": "showOwn"
		"click .taisties__show-recommended": "showRecommended"

	constructor: (element, url, taistieCollection)->
		@_taistieCollection = taistieCollection
		super el: element
		@_url = url
		@_taistieCollection.bind("refresh", @addAll)
		@_taistieCollection.fetch()

	addOne: (taistie) =>
		view = new TaistieView(item: taistie)
		list = if taistie.isOwnTaistie() then @own else @recommended
		list.append(view.render().el)
		view

	addAll: =>
		@addOne taistie for taistie in @_taistieCollection.getLocalTaistiesForUrl @_url

	addOwn: =>
		@_taistieCollection.getAllOwnTaisties() =>
			@addOne taistie for taistie in taisties

	create: =>
		newTaistie = @_taistieCollection.create
				name: ""
				active: false

		newView = @addOne newTaistie
		newView.startEditing()

	showOwn: =>
			@own.empty()
			@recommended.empty()
			@addOwn
			@.el.addClass 'm-own'

	showRecommended: =>
			@own.empty()
			@recommended.empty()
			@addAll
			@.el.removeClass 'm-own'
