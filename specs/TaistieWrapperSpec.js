describe("TaistieWrapper", function() {
	var taistieWrapper
	beforeEach(function() {
		taistieWrapper = new TaistieWrapper()
	})

	it('wraps combined taisties code in functional expression', function() {
		var taistiesCode = {css: 'css', js: 'js'}

		taistieWrapper._addCodeToDocument = 'addCodeFunction'
		taistieWrapper._insertCodeNode = 'insertNodeFunction'

		expect(taistieWrapper.wrapTaistiesCodeToJs(taistiesCode)).toEqual('(addCodeFunction)({"css":"css","js":"js"}, insertNodeFunction)')
	})

	it('returns null if both js and css are empty', function() {
		expect(taistieWrapper.wrapTaistiesCodeToJs({css: '', js: ''})).toEqual(null)
	})

	describe("has wrapping code that inserts given js and css to document", function() {
		var insertCodeCallArgs
		var mockInsertCodeNodeFunction = function(tagName, type, code) {insertCodeCallArgs.push([tagName, type, code])
		}
		beforeEach(function() {insertCodeCallArgs = []})

		it('inserts non-empty css and js to document', function() {
			_expectCreationAndInsertion({css: 'cssCode', js: 'jsCode'}, [
				['style', 'text/css', 'cssCode'],
				['script', 'text/javascript', 'jsCode']
			])
		})

		it('skips empty css', function() {
			_expectCreationAndInsertion({css: '', js: 'jsCode'}, [['script', 'text/javascript', 'jsCode']])
		})

		it('skips empty js', function() {
			_expectCreationAndInsertion({css: 'cssCode', js: ''}, [
				['style', 'text/css', 'cssCode']
			])
		})

		function _expectCreationAndInsertion(insertedCssAndJs, expectedCreatedElements) {
			taistieWrapper._addCodeToDocument(insertedCssAndJs, mockInsertCodeNodeFunction)
			expect(insertCodeCallArgs).toEqual(expectedCreatedElements)
		}

	})
})