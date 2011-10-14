describe 'Taistie', ->
	it 'defines whether it fits url by regexp', ->
		taistie = new Taistie
		taistie.setTaistieData urlRegexp: 'targetsite\\.com'
		expect(taistie.fitsUrl 'http://targetsite.com').toBeTruthy()
		expect(taistie.fitsUrl 'http://targetsite.com/subfolder').toBeTruthy()
		expect(taistie.fitsUrl 'http://other.com').toBeFalsy()

	it "returns css directly from data", ->
		taistie = new Taistie
		taistie.setTaistieData urlRegexp: 'stub', css: 'css code'
		expect(taistie.getCss()).toEqual 'css code'

	it 'returns js as functional expression', ->
		taistie = new Taistie
		taistie.setTaistieData urlRegexp: 'stub', js: 'return true'
		expect(taistie.getJs()).toEqual '(function(){return true})();'

	it "has empty css and js if they are not given", ->
		taistie = new Taistie
		taistie.setTaistieData urlRegexp: 'stub'

		expect(taistie.getCss()).toEqual ''
		expect(taistie.getJs()).toEqual ''