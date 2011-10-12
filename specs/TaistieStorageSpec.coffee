describe 'TaistieStorage', ->
	taistieStorage = undefined
	beforeEach ->
		taistieStorage = new TaistiesStorage
	it 'includes locally developed taistie if it has "use" flag ON', ->
		DevelopedTaistie.use = true
		expect(taistieStorage.getAllTaisties().length).toEqual 1

	it 'doesn\'t include developed taistie if it has "use" flag OFF', ->
		DevelopedTaistie.use = false
		expect(taistieStorage.getAllTaisties().length).toEqual 0



