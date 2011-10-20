describe "TaistieCombiner", ->
	taistieCombiner = undefined

	createTaistie = (taistieData) ->
		taistie = new Taistie
		taistie.setTaistieData taistieData
		taistie._active = on
		return taistie

	beforeEach ->
		taistieCombiner = new TaistieCombiner()

	it "gets whole js and css code for taisties", ->
		taistie1 = createTaistie urlRegexp: '.*', css: '|css1|', js: ''
		taistie2 = createTaistie urlRegexp: '.*', css: '', js: '|js2|'
		taistie3 = createTaistie urlRegexp: '.*', css: '|css3|', js: '|js3|'

		taistieCombiner._dTaistiesStorage =
			getAllTaisties: -> return [taistie1, taistie2,taistie3]

		expect(taistieCombiner.getAllCssAndJsForUrl 'some_url').toEqual
			css: taistie1.getCss() + taistie3.getCss(),
			js: taistie2.getJs() + taistie3.getJs()

	it "gets css and js only for taisties fitting tab", ->
		fittingTaistie = createTaistie
			urlRegexp: 'fitting\\.com',
			css: 'fittingTaistie {color: green}',
			js: 'alert(fittingTaistie)'

		nonFittingTaistie = createTaistie
			urlRegexp: 'nonfitting\\.com',
			css: 'nonFittingTaistie {color: red}',
			js: 'alert(nonFittingTaistie)'

		taistieCombiner._dTaistiesStorage =
			getAllTaisties: ->
				return [
					fittingTaistie,
					nonFittingTaistie
				]

		expect(taistieCombiner.getAllCssAndJsForUrl 'fitting.com').toEqual
			css: fittingTaistie.getCss(),
			js: fittingTaistie.getJs()

	it 'takes valid non-empty url', ->
		expect(-> taistieCombiner.getAllCssAndJsForUrl null).toThrow new AssertException 'url should be given'
		expect(-> taistieCombiner.getAllCssAndJsForUrl '').toThrow new AssertException 'url should be given'
