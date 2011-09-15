describe("Taistie", function() {

	it("defines whether it fits url by regexp", function(){
		var taistie = new Taistie({siteRegexp: 'targetsite\\.com'})

		expect(taistie.fitsUrl('http://targetsite.com')).toBeTruthy()
		expect(taistie.fitsUrl('http://targetsite.com/subfolder')).toBeTruthy()
		expect(taistie.fitsUrl('http://other.com')).toBeFalsy()
	})

	it("takes jslibs, css and js from 'contents' property of given taistie data", function() {

		var taistie = new Taistie({js: 'js code', css: 'css code'})

		expect(taistie.getCss()).toEqual('css code')
		expect(taistie.getJs()).toEqual('js code')
	})

	it("has empty jslibs, css and js if they are not given", function() {
		var taistie = new Taistie({})

		expect(taistie.getCss()).toEqual('')
		expect(taistie.getJs()).toEqual('')
	})

})