describe("TaistieCombiner", function() {
	var taistieCombiner
	beforeEach(function() {
		taistieCombiner = new TaistieCombiner()
	})
	it("gets whole js and css code for taisties", function() {
		var taistie1 = new Taistie({urlRegexp: '.*', css: '|css1|', js: ''})
		var taistie2 = new Taistie({urlRegexp: '.*', css: '', js: '|js2|'})
		var taistie3 = new Taistie({urlRegexp: '.*', css: '|css3|', js: '|js3|'})

		taistieCombiner.setTaistiesStorage({
			getAllTaisties: function() {
				return [taistie1, taistie2,taistie3]
			}
		})

		expect(taistieCombiner.getAllCssAndJsForUrl('some_url')).toEqual({
			css: taistie1.getCss() + taistie3.getCss(),
			js: taistie2.getJs() + taistie3.getJs()
		})
	})

	it("gets css and js only for taisties fitting tab", function() {
		var fittingTaistie = new Taistie({urlRegexp: 'fitting\\.com', css: 'fittingTaistie {color: green}', js: 'alert(fittingTaistie)'})
		var nonFittingTaistie = new Taistie({urlRegexp: 'nonfitting\\.com', css: 'nonFittingTaistie {color: red}', js: 'alert(nonFittingTaistie)'})

		taistieCombiner.setTaistiesStorage({
			getAllTaisties: function() {
				return [
					fittingTaistie,
					nonFittingTaistie
				]
			}
		})

		expect(taistieCombiner.getAllCssAndJsForUrl('fitting.com')).toEqual({
			css: fittingTaistie.getCss(),
			js: fittingTaistie.getJs()
		})
	})

	it('takes valid non-empty url', function() {
		expect(function(){taistieCombiner.getAllCssAndJsForUrl(null)}).toThrow(new AssertException('url should be given'))
		expect(function(){taistieCombiner.getAllCssAndJsForUrl('')}).toThrow(new AssertException('url should be given'))
	})

})