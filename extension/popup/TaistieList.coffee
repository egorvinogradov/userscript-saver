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
		list = @recommended
		list.append(view.render().el)
		view

	addAll: =>
		@addOne taistie for taistie in @_taistieCollection.getCachedTaistiesForUrl @_url

	create: =>
		newTaistie = @_taistieCollection.create
				name: ""
				active: false

		newView = @addOne newTaistie
		newView.startEditing()

	#TODO: убрать - нет больше собственных taistie
	showOwn: =>
			@own.empty()
			@recommended.empty()
			@.el.addClass 'm-own'

	showRecommended: =>
			@own.empty()
			@recommended.empty()
			@addAll
			@.el.removeClass 'm-own'
