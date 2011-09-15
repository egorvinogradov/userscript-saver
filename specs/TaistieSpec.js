describe("Taistie", function() {

	it("defines whether it fits url by regexp", function(){
		var taistie = new Taistie({urlRegexp: 'targetsite\\.com'})

		expect(taistie.fitsUrl('http://targetsite.com')).toBeTruthy()
		expect(taistie.fitsUrl('http://targetsite.com/subfolder')).toBeTruthy()
		expect(taistie.fitsUrl('http://other.com')).toBeFalsy()
	})

	it("returns css directly from data", function() {
		var taistie = new Taistie({urlRegexp: 'stub', css: 'css code'})

		expect(taistie.getCss()).toEqual('css code')
	})

	it('returns js as functional expression', function() {
		var taistie = new Taistie({urlRegexp: 'stub', js: 'return true'})

		expect(taistie.getJs()).toEqual('(function(){return true})();')
	})
	it("has empty css and js if they are not given", function() {
		var taistie = new Taistie({urlRegexp: 'stub'})

		expect(taistie.getCss()).toEqual('')
		expect(taistie.getJs()).toEqual('')
	})

})