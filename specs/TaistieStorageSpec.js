describe('TaistieStorage', function(){
	var taistieStorage

	beforeEach(function() {
		taistieStorage = new TaistiesStorage()
	})

	it('includes locally developed taistie if it has "use" flag ON', function() {
		DevelopedTaistie.use = true
		expect(taistieStorage.getAllTaisties().length).toEqual(1)
	})

	it('doesn\'t include developed taistie if it has "use" flag OFF', function() {
		DevelopedTaistie.use = false
		expect(taistieStorage.getAllTaisties().length).toEqual(0)
	})
})