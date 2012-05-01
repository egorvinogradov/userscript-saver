describe "TaistieCombiner", ->
	taistieCombiner = undefined

	mockTaistieCollection =
		#return just all taisties - ulr fitting is checked in Taistie specs
		getTaistiesForUrl: (url) -> @taisties

	beforeEach ->
		mockTaistieCollection.taisties = []
		taistieCombiner = new TaistieCombiner()
		taistieCombiner._taistieCollection = mockTaistieCollection

	createTaistie = (taistieData) ->
		#by default turn taistie on
		taistieData.active ?= on
		taistie = new Taistie taistieData
		mockTaistieCollection.taisties.push taistie
		return taistie

	it "gets whole js and css code for taisties", ->
		cssOnly = createTaistie rootUrl: '.*', css: '|css1|', js: ''
		jsOnly = createTaistie rootUrl: '.*', css: '', js: '|js2|'
		jsAndCss = createTaistie rootUrl: '.*', css: '|css3|', js: '|js3|'
		
		expect(taistieCombiner.getAllCssAndJsForUrl 'some_url').toEqual
			css: cssOnly.getCss() + '\n\n' + jsAndCss.getCss(),
			js: jsOnly.getJs() + '\n\n' + jsAndCss.getJs()
