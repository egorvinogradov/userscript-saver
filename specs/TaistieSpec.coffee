describe 'Taistie', ->
	afterEach ->
		Taistie.destroyAll()

	it 'defines whether it fits url by regexp', ->
		taistie = Taistie.create urlRegexp: 'targetsite\\.com'
		expect(taistie.fitsUrl 'http://targetsite.com').toBeTruthy()
		expect(taistie.fitsUrl 'http://targetsite.com/subfolder').toBeTruthy()
		expect(taistie.fitsUrl 'http://other.com').toBeFalsy()

	it "returns css directly from data", ->
		taistie = Taistie.create urlRegexp: 'stub', css: 'css code'
		expect(taistie.getCss()).toEqual 'css code'

	it 'returns js as functional expression text', ->
		taistie = Taistie.create urlRegexp: 'stub', js: 'return true'
		expect(taistie.getJs()).toEqual '(function(){return true})();'

	it "has empty css and js if they are not given", ->
		taistie = Taistie.create urlRegexp: 'stub'

		expect(taistie.getCss()).toEqual ''
		expect(taistie.getJs()).toEqual ''

	describe 'getTaistiesForUrl', ->
		mockUserscriptsDownloader =
			getUserscriptsForUrl: -> []
		Taistie._userscriptsDownloader = mockUserscriptsDownloader

		it 'gives taisties that fit to url', ->
			expect(Taistie.getTaistiesForUrl 'http://aaa.com').toEqual []

			fittingTaistie = Taistie.create urlRegexp: 'aaa\.com'
			unfittingTaistie = Taistie.create urlRegexp: 'bbb\.com'
			expect(Taistie.getTaistiesForUrl 'http://aaa.com').toEqual [fittingTaistie]

		it 'takes valid non-empty url', ->
			expect(-> Taistie.getTaistiesForUrl null).toThrow new AssertException 'url should be given'
			expect(-> Taistie.getTaistiesForUrl '').toThrow new AssertException 'url should be given'

		it 'gets taisties from userstyles.org - saves them and omits duplicates', ->
			userscript =
				urlRegexp: 'aaa\.com'
				js: '<js here>'
				name: 'userscript1'
				id: 1
			spyOn(mockUserscriptsDownloader, 'getUserscriptsForUrl').andReturn [userscript]

			taisties = Taistie.getTaistiesForUrl 'http://aaa.com'
			expect(mockUserscriptsDownloader.getUserscriptsForUrl).toHaveBeenCalledWith 'http://aaa.com'
			expect(taisties.length).toEqual(1)
			taistie = taisties[0]
			expect([taistie.name, taistie.js, taistie.urlRegexp, taistie.source, taistie.externalId]).
				toEqual [userscript.name, userscript.js, userscript.urlRegexp, 'userscripts', userscript.id]

			expect(Taistie.getTaistiesForUrl('http://aaa.com').length).toEqual 1

