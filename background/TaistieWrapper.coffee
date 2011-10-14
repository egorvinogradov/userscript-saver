class TaistieWrapper

	wrapTaistiesCodeToJs: (allTaistiesCssAndJs) ->
		hasJsOrCss = allTaistiesCssAndJs.js.length > 0 or allTaistiesCssAndJs.css.length > 0
		if hasJsOrCss then @_getPlainCodeToInsertToDocument allTaistiesCssAndJs else null

	_getPlainCodeToInsertToDocument: (cssAndJsCode) ->
		'(' + @_addCodeToDocument.toString() + ')(' + JSON.stringify(cssAndJsCode) + ', ' + @_insertCodeNode.toString() + ')'

	_addCodeToDocument: (cssAndJsCode, insertNodeFunction) ->
		insertedNodeDescriptors =
			css:
				tagName: 'style'
				type: 'text/css'
			js:
				tagName: 'script'
				type: 'text/javascript'

		codeTypes = ['css','js']
		codeTypes.forEach (codeType) ->
			if cssAndJsCode[codeType].length > 0
				insertedNodeDescriptor = insertedNodeDescriptors[codeType]
				insertNodeFunction(insertedNodeDescriptor.tagName, insertedNodeDescriptor.type, cssAndJsCode[codeType])

	_insertCodeNode:  (tagName, type, code) ->
		insertedElement = document.createElement(tagName)
		insertedElement.setAttribute('type', type)
		insertedElement.textContent = code
		document.querySelector('body').appendChild(insertedElement)
