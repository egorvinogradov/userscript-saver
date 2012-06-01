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

	it 'returns js for insertion as functional expression text', ->
		taistie = new Taistie rootUrl: 'stub', js: 'return true'
		expect(taistie.getJsForInsertion()).toEqual '(function(){return true})();'

	it 'gets raw js with getRawJs', ->
		taistie = new Taistie js: 'return true;'
		expect(taistie.getRawJs()).toEqual 'return true;'

	it "has empty css and js if they are not given", ->
		taistie = new Taistie rootUrl: 'stub'

		expect(taistie.getCss()).toEqual ''
		expect(taistie.getJsForInsertion()).toEqual ''

	it 'gives description with getDescription', ->
		taistie = new Taistie description: 'some text'
		expect(taistie.getDescription()).toEqual 'some text'

	it 'gives root URL with getRootUrl', ->
		taistie = new Taistie rootUrl: 'rooturl.com'
		expect(taistie.getRootUrl()).toEqual 'rooturl.com'

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
		expectedUrl = undefined
		mockedResults = undefined
		beforeEach ->
			mockedResults = []
			expectedUrl = undefined
			Taistie._userscriptsDownloader = getUserscriptsForUrl: (url, callback) ->
				expectedUrl = url
				callback mockedResults

		it 'gives taisties that fit to url', ->
			Taistie.getTaistiesForUrl 'http://urlWithNoTaisties.com', (taisties)->
				expect(taisties).toEqual []

			fittingTaistie = Taistie.create rootUrl: 'aaa.com'
			unfittingTaistie = Taistie.create rootUrl: 'bbb.com'
			Taistie.getTaistiesForUrl 'http://aaa.com', (taisties)->
				expect(taisties).toEqual [fittingTaistie]

		it 'doesn\'t load userscripts if any userscript for current url already exists', ->
			userscript = Taistie.create
				source: 'userscripts'
				rootUrl: 'aaa.com'

			Taistie.getTaistiesForUrl 'http://aaa.com', (taisties) ->
				expect(expectedUrl).not.toBeDefined()

		it 'takes valid non-empty url', ->
			expect(-> Taistie.getTaistiesForUrl null).toThrow new AssertException 'url should be given'
			expect(-> Taistie.getTaistiesForUrl '').toThrow new AssertException 'url should be given'

		it 'gets taisties from userstyles.org - saves them and omits duplicates', ->
			userscript =
				rootUrl: 'aaa\.com'
				js: '<js here>'
				name: 'userscript1'
				id: 1
				description: 'some description'
			mockedResults = [userscript]

			Taistie.getTaistiesForUrl 'http://aaa.com', (taisties) ->
				expect(expectedUrl).toEqual 'http://aaa.com'
				expect(taisties.length).toEqual(1)

				taistie = taisties[0]
				expect([taistie.name, taistie.js, taistie.rootUrl, taistie.source, taistie.externalId,
					taistie.description]).
					toEqual [userscript.name, userscript.js, userscript.rootUrl, 'userscripts', userscript.id,
					userscript.description]

				Taistie.getTaistiesForUrl 'http://aaa.com', (taisties) ->
					expect(taisties.length).toEqual 1

	it 'getActiveTaistiesForUrl: gets all active taisties that fit given url assuming they all are loaded locally', ->
		activeFittingTaistie = Taistie.create
			active: true
			rootUrl: 'current.com'
		inactiveFittingTaistie = Taistie.create
			active: false
			rootUrl: 'current.com'
		activeOtherTaistie = Taistie.create
			active: true
			rootUrl: 'other.com'

		expect(Taistie.getActiveTaistiesForUrl 'http://current.com').toEqual [activeFittingTaistie]

	it 'getAllOwnTaisties: gets all own taisties', ->
		defaultOwnTaistie = Taistie.create {}
		ownActive = Taistie.create {active: true}
		ownInactive = Taistie.create {source: 'own', active: false}

		userscriptActive = Taistie.create {source: 'userscripts', active: true}
		userscriptInactive = Taistie.create {source: 'userscripts', active: false}

		expect(Taistie.getAllOwnTaisties()).toEqual [defaultOwnTaistie, ownActive, ownInactive]