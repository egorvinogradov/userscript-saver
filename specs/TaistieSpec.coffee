describe 'Taistie', ->
	afterEach ->
		Taistie.destroyAll()

	it 'fits url if @rootUrl is a substring of full server name in url', ->
		taistie = new Taistie rootUrl: 'targetsite.com'
		expect(taistie.fitsUrl 'http://targetsite.com').toBeTruthy()
		expect(taistie.fitsUrl 'http://targetsite.com/subfolder').toBeTruthy()

		expect(taistie.fitsUrl 'http://other.com').toBeFalsy()

		#TODO: проверять не по всей строке, а только по полному имени сервера - без дальнейших параметров
#		expect(taistie.fitsUrl 'http://other.com/targetsite.com').toBeFalsy()

	it "returns css directly from data", ->
		taistie = new Taistie rootUrl: 'stub', css: 'css code'
		expect(taistie.getCss()).toEqual 'css code'

	it 'returns js as functional expression text', ->
		taistie = new Taistie rootUrl: 'stub', js: 'return true'
		expect(taistie.getJs()).toEqual '(function(){return true})();'

	it "has empty css and js if they are not given", ->
		taistie = new Taistie rootUrl: 'stub'

		expect(taistie.getCss()).toEqual ''
		expect(taistie.getJs()).toEqual ''

	it 'gives description with getDescription', ->
		taistie = new Taistie description: 'some text'
		expect(taistie.getDescription()).toEqual 'some text'

	it 'gives external id with getExternalId', ->
		taistie = new Taistie externalId: 555
		expect(taistie.getExternalId()).toEqual 555

	it 'getExternalLink: gives link to userscript page for userscript and null otherwise', ->
		userscriptTaistie = new Taistie
			source: 'userscripts'
			externalId: 555
		expect(userscriptTaistie.getExternalLink()).toEqual('http://userscripts.org/scripts/show/555')

		expect((new Taistie {}).getExternalLink()).toBeNull()

	it 'gives current usage count with getUsageCount', ->
		taistie = new Taistie usageCount: 134
		expect(taistie.getUsageCount()).toEqual 134

	it 'constructor requires field values', ->
		expect(-> new Taistie).toThrow 'Taistie creation: field values data required (in dictionary)'

	describe '\'source\' field', ->
		it 'can be null or one of [\'own\', \'userscripts\']', ->
			correctTaistie = new Taistie({})
			correctTaistie = new Taistie source: 'own'
			correctTaistie = new Taistie source: 'userscripts'

			expect(-> new Taistie(source: 'other')).toThrow('Taistie creation: invalid \'source\' value \'other\'')

		it 'either isOwnTaistie() or isUserscript() is true depending on given \'source\' field', ->
			for taistieData in [{}, {source: 'own'}]
				do(taistieData) ->

					ownTaistie = new Taistie taistieData
					expect(ownTaistie.isOwnTaistie()).toBeTruthy()
					expect(ownTaistie.isUserscript()).toBeFalsy()

			userscriptTaistie = new Taistie source: 'userscripts'
			expect(userscriptTaistie.isUserscript()).toBeTruthy()

	describe 'getTaistiesForUrl', ->
		mockUserscriptsDownloader =
			getUserscriptsForUrl: -> []
		Taistie._userscriptsDownloader = mockUserscriptsDownloader

		it 'gives taisties that fit to url', ->
			expect(Taistie.getTaistiesForUrl 'http://aaa.com').toEqual []

			fittingTaistie = Taistie.create rootUrl: 'aaa\.com'
			unfittingTaistie = Taistie.create rootUrl: 'bbb\.com'
			expect(Taistie.getTaistiesForUrl 'http://aaa.com').toEqual [fittingTaistie]

		it 'takes valid non-empty url', ->
			expect(-> Taistie.getTaistiesForUrl null).toThrow new AssertException 'url should be given'
			expect(-> Taistie.getTaistiesForUrl '').toThrow new AssertException 'url should be given'

		it 'gets taisties from userstyles.org - saves them and omits duplicates', ->
			userscript =
				rootUrl: 'aaa\.com'
				js: '<js here>'
				name: 'userscript1'
				id: 1
			spyOn(mockUserscriptsDownloader, 'getUserscriptsForUrl').andReturn [userscript]

			taisties = Taistie.getTaistiesForUrl 'http://aaa.com'
			expect(mockUserscriptsDownloader.getUserscriptsForUrl).toHaveBeenCalledWith 'http://aaa.com'
			expect(taisties.length).toEqual(1)
			taistie = taisties[0]
			expect([taistie.name, taistie.js, taistie.rootUrl, taistie.source, taistie.externalId]).
				toEqual [userscript.name, userscript.js, userscript.rootUrl, 'userscripts', userscript.id]

			expect(Taistie.getTaistiesForUrl('http://aaa.com').length).toEqual 1

	it 'getAllOwnTaisties: gets all own taisties', ->
		defaultOwnTaistie = Taistie.create {}
		ownActive = Taistie.create {active: true}
		ownInactive = Taistie.create {source: 'own', active: false}

		userscriptActive = Taistie.create {source: 'userscripts', active: true}
		userscriptInactive = Taistie.create {source: 'userscripts', active: false}

		expect(Taistie.getAllOwnTaisties()).toEqual [defaultOwnTaistie, ownActive, ownInactive]
