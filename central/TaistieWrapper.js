TaistieWrapper = function() {
}

TaistieWrapper.prototype.wrapTaistiesCodeToJs = function(allTaistiesCssAndJs) {
	return (allTaistiesCssAndJs.js.length > 0 || allTaistiesCssAndJs.css.length
			> 0) ? this._getPlainCodeToInsertToDocument(allTaistiesCssAndJs) : null
}

TaistieWrapper.prototype._getPlainCodeToInsertToDocument = function(cssAndJsCode) {
	return '(' + this._addCodeToDocument.toString() + ')(' + JSON.stringify(cssAndJsCode) + ', '
			       + this._insertCodeNode.toString() + ')'
}

TaistieWrapper.prototype._addCodeToDocument = function(cssAndJsCode, insertNodeFunction) {
	var insertedNodeDescriptors = {
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
			var insertedNodeDescriptor = insertedNodeDescriptors[codeType]
			insertNodeFunction(insertedNodeDescriptor.tagName, insertedNodeDescriptor.type, cssAndJsCode[codeType])
		}
	})
}

TaistieWrapper.prototype._insertCodeNode = function (tagName, type, code) {
	var insertedElement = document.createElement(tagName)
	insertedElement.setAttribute('type', type)
	insertedElement.textContent = code
	document.querySelector('body').appendChild(insertedElement)
}
