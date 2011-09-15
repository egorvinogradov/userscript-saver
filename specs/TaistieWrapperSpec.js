describe("TaistieWrapper", function() {
	var taistieWrapper
	beforeEach(function() {
		taistieWrapper = new TaistieWrapper()
	})

	it('wraps combined taisties code in functional expression', function() {
		var taistiesCode = {css: 'css', js: 'js'}
		var mockInsertFunction = function(document, unusedArgs) {var local = unusedArgs}
		taistieWrapper._insertFunction = mockInsertFunction

		expect(taistieWrapper.wrapTaistiesCodeToJs(taistiesCode)).toEqual('(' + mockInsertFunction.toString() + ')(document, ' + JSON.stringify(taistiesCode) + ')')
	})

	it('returns null if both js and css are empty', function() {
		expect(taistieWrapper.wrapTaistiesCodeToJs({css: '', js: ''})).toEqual(null)
	})
})