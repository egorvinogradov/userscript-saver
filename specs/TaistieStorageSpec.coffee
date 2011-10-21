describe 'TaistieStorage', ->
	taistieStorage = undefined
	beforeEach ->
		taistieStorage = new TaistiesStorage
	it 'includes locally developed taistie', ->
		allTaisties = taistieStorage.getAllTaisties()
		expect(allTaisties.length).toEqual 1



