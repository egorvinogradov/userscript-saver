describe("Taistie", function() {

	it("defines whether it fits url by regexp", function(){
		var taistie = new Taistie({siteRegexp: 'targetsite\\.com', contents: {}})
		expect(taistie.fitsUrl('http://targetsite.com')).toBeTruthy()
		expect(taistie.fitsUrl('http://targetsite.com/subfolder')).toBeTruthy()
		expect(taistie.fitsUrl('http://other.com')).toBeFalsy()
	})

	it("takes jslibs, css and js from 'contents' property of given taistie data", function() {

		var taistie = new Taistie({contents: {js: 'js code here', css: 'css code here', jslibs: ['lib1.js', 'lib2.js']}})

		expect(taistie.getJsLibs()).toEqual(['lib1.js', 'lib2.js'])
		expect(taistie.getCss()).toEqual('css code here')
		expect(taistie.getJs()).toEqual('js code here')
	})

	it("expects existing non-empty 'contents' property in taistie data", function () {
		expect(function() {
			new Taistie({})
		}).toThrow(new Error("taistieData should contain 'contents'"))
	})

	it("has empty jslibs, css and js if they are not given", function() {
		var taistie = new Taistie({contents: {}})
		expect(taistie.getJsLibs()).toEqual([])
		expect(taistie.getCss()).toEqual('')
		expect(taistie.getJs()).toEqual('')
	})

})