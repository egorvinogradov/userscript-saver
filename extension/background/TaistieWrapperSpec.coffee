describe "TaistieWrapper", ->
	taistieWrapper = null
	beforeEach(-> taistieWrapper = new TaistieWrapper)

	it 'wraps combined taisties code in functional expression', ->
		taistiesCode =
			css: 'css'
			js: 'js'

		taistieWrapper._addCodeToDocument = 'addCodeFunction'
		taistieWrapper._insertCodeNode = 'insertNodeFunction'

		expect(taistieWrapper.wrapTaistiesCodeToJs taistiesCode).toEqual '(addCodeFunction)({"css":"css","js":"js"}, insertNodeFunction)'

	it 'returns null if both js and css are empty', ->
		expect(taistieWrapper.wrapTaistiesCodeToJs css: '', js: '').toEqual null

	describe "has wrapping code that inserts given js and css to document", ->
		insertCodeCallArgs = null
		mockInsertCodeNodeFunction = (tagName, type, code) -> insertCodeCallArgs.push [tagName, type, code]

		beforeEach(->insertCodeCallArgs = [])

		it 'inserts non-empty css and js to document', ->
			expectCreationAndInsertion {css: 'cssCode', js: 'jsCode'}, [
				['style', 'text/css', 'cssCode'],
				['script', 'text/javascript', 'jsCode']
			]

		it 'skips empty css', ->
			expectCreationAndInsertion {css: '', js: 'jsCode'}, [['script', 'text/javascript', 'jsCode']]

		it 'skips empty js', ->
			expectCreationAndInsertion {css: 'cssCode', js: ''}, [
				['style', 'text/css', 'cssCode']
			]

		expectCreationAndInsertion = (insertedCssAndJs, expectedCreatedElements) ->
			taistieWrapper._addCodeToDocument insertedCssAndJs, mockInsertCodeNodeFunction
			expect(insertCodeCallArgs).toEqual expectedCreatedElements
