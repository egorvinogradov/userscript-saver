describe "TaistieCombiner", ->
	taistieCombiner = undefined

	createTaistie = (taistieData) ->
		taistie = new Taistie
		taistie.setTaistieData taistieData

		#by default turn taistie on
		taistie.active ?= on
		return taistie

	beforeEach ->
		taistieCombiner = new TaistieCombiner()

	it "gets whole js and css code for taisties", ->
		cssOnly = createTaistie urlRegexp: '.*', css: '|css1|', js: ''
		jsOnly = createTaistie urlRegexp: '.*', css: '', js: '|js2|'
		jsAndCss = createTaistie urlRegexp: '.*', css: '|css3|', js: '|js3|'

		taistieCombiner._dTaistiesStorage =
			getAllTaisties: -> return [cssOnly, jsOnly,jsAndCss]

		expect(taistieCombiner.getAllCssAndJsForUrl 'some_url').toEqual
			css: cssOnly.getCss() + '\n\n' + jsAndCss.getCss(),
			js: jsOnly.getJs() + '\n\n' + jsAndCss.getJs()

	it "gets css and js only for taisties fitting tab and active; joins them with newlines", ->
		nonFittingTaistie = createTaistie
			urlRegexp: 'nonfitting\\.com'
			css: 'nonFittingTaistie'
			js: 'alert(nonFittingTaistie)'

		fittingActiveTaistie1 = createTaistie
			urlRegexp: 'fitting\\.com'
			css: 'fitting active 1'
			js: 'alert(\'fitting active 1\')'

		fittingActiveTaistie2 = createTaistie
			urlRegexp: 'fitting\\.com'
			css: 'fitting active 2'
			js: 'alert(\'fitting active 2\')'

		fittingInactiveTaistie = createTaistie
			urlRegexp: 'fitting\\.com'
			css: 'fitting inactive'
			js: 'alert(\'fitting inactive\')'
			active: false

		taistieCombiner._dTaistiesStorage =
			getAllTaisties: ->
				return [
					fittingInactiveTaistie,
					fittingActiveTaistie1,
					nonFittingTaistie,
					fittingActiveTaistie2
				]

		expect(taistieCombiner.getAllCssAndJsForUrl 'other.com').toEqual null

		expect(taistieCombiner.getAllCssAndJsForUrl 'fitting.com').toEqual
			css: fittingActiveTaistie1.getCss() + '\n\n' + fittingActiveTaistie2.getCss()
			js: fittingActiveTaistie1.getJs() + '\n\n' + fittingActiveTaistie2.getJs()

	it 'takes valid non-empty url', ->
		expect(-> taistieCombiner.getAllCssAndJsForUrl null).toThrow new AssertException 'url should be given'
		expect(-> taistieCombiner.getAllCssAndJsForUrl '').toThrow new AssertException 'url should be given'
