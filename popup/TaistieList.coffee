class TaistieList extends Spine.Controller
	elements:
		".taisties__list-own": "own"
		".taisties__list-recommended": "recommended"
	events:
		"click .taisties__create": "create"
		"click .taisties__show-created": "showOwn"

	constructor: (element, url, taistieCollection)->
		@_taistieCollection = taistieCollection
		super el: element
		@_url = url
		@_taistieCollection.bind("refresh", @addAll)
		@_taistieCollection.fetch()

	addOne: (taistie) =>

		list = if taistie.isOwnTaistie() then @own else @recommended
		view = new TaistieView(item: taistie)
		list.append(view.render().el)
		view

	addAll: =>
		@_taistieCollection.getTaistiesForUrl @_url, (taisties) =>
			@addOne taistie for taistie in taisties

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
		if @.el.hasClass 'm-own'
			@addAll
			@.el.removeClass 'm-own'
		else
			@recommended.empty()
			@addOwn
			@.el.addClass 'm-own'