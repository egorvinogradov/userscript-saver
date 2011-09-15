describe("PageTaistier", function() {
	var pageTaistier
	beforeEach(function() {
		pageTaistier = new PageTaistier()
	})
	it("gets whole js and css code for taisties", function() {
		var taistie1 = new Taistie({urlRegexp: '.*', css: 'taistie1 {color: red}', js: ''})
		var taistie2 = new Taistie({urlRegexp: '.*', css: '', js: 'alert(taistie2)'})
		var taistie3 = new Taistie({urlRegexp: '.*', css: 'taistie3 {color: blue}', js: 'alert(taistie3)'})

		pageTaistier.setTaistiesStorage({
			getAllTaisties: function() {
				return [taistie1, taistie2,taistie3]
			}
		})

		expect(pageTaistier.getAllCssAndJsForUrl('some_url')).toEqual({
			css: taistie1.getCss() + taistie3.getCss(),
			js: taistie2.getJs() + taistie3.getJs()
		})
	})

	it("gets css and js only for taisties fitting tab", function() {
		var fittingTaistie = new Taistie({urlRegexp: 'fitting\\.com', css: 'fittingTaistie {color: green}', js: 'alert(fittingTaistie)'})
		var nonFittingTaistie = new Taistie({urlRegexp: 'nonfitting\\.com', css: 'nonFittingTaistie {color: red}', js: 'alert(nonFittingTaistie)'})

		pageTaistier.setTaistiesStorage({
			getAllTaisties: function() {
				return [
					fittingTaistie,
					nonFittingTaistie
				]
			}
		})

		expect(pageTaistier.getAllCssAndJsForUrl('fitting.com')).toEqual({
			css: fittingTaistie.getCss(),
			js: fittingTaistie.getJs()
		})
	})

	it('takes valid non-empty url', function() {
		expect(function(){pageTaistier.getAllCssAndJsForUrl(null)}).toThrow(new AssertException('url should be given'))
		expect(function(){pageTaistier.getAllCssAndJsForUrl('')}).toThrow(new AssertException('url should be given'))
	})

})