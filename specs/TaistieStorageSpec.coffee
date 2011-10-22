describe 'TaistieStorage', ->
	taistieStorage = undefined
	beforeEach ->
		taistieStorage = new TaistiesStorage
	it 'includes locally developed taistie', ->
		developedTaistie =
			urlRegexp: 'site\\.com'
			css: 'developed_css'
			js: 'developed_js'
			active: on
		taistieStorage._developedTaistie = developedTaistie
		allTaisties = taistieStorage.getAllTaisties()
		expect(allTaisties.length).toEqual 1
		newTaistie = allTaisties[0]
		expect(newTaistie.getCss()).toEqual developedTaistie.css


