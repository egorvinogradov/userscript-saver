TaistieWrapper = function() {
}

TaistieWrapper.prototype.wrapTaistiesCodeToJs = function(allTaistiesCssAndJs) {
	return (allTaistiesCssAndJs.js.length > 0 || allTaistiesCssAndJs.css.length
			> 0) ? this._getCodeToInsert(allTaistiesCssAndJs) : null
}

TaistieWrapper.prototype._getCodeToInsert = function(cssAndJsCode) {
	return '(' + this._insertFunction.toString() + ')(document, ' + JSON.stringify(cssAndJsCode) + ')'
}

TaistieWrapper.prototype._insertFunction = function(documentObject, cssAndJsCode) {
	var insertedElementDescriptors = {
		css: {
			tagName: 'style',
			type: 'text/css'
		},
		js: {
			tagName: 'script',
			type: 'text/javascript'
		}
	}

	var codeTypes = ['css','js']
	codeTypes.forEach(function(codeType) {
		if (cssAndJsCode[codeType].length > 0) {
			insertCode(insertedElementDescriptors[codeType], cssAndJsCode[codeType])
		}
	})

	function insertCode(elementDescriptor, code) {
		var insertedElement = documentObject.createElement(elementDescriptor.tagName)
		insertedElement.setAttribute('type', elementDescriptor.type)
		insertedElement.textContent = code
		documentObject.querySelector('body').appendChild(insertedElement)
	}
}