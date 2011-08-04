// ==UserScript==
// @include http://*/*
// @include https://*/*
// ==/UserScript==

Taist.Embedder = function(docInstance) {
	this.doc = docInstance
	this.appendTo = this.doc.querySelector('body')
}
Taist.Embedder.prototype = {
	insertionParams: {
		css : {
			tagName : 'style',
			typeAttribute : 'text/css',
			insertedProperty : 'textContent'
		},
		js : {
			tagName : 'script',
			typeAttribute : 'text/javascript',
			insertedProperty : 'textContent'
		},
		jslib : {
			tagName : 'script',
			typeAttribute : 'text/javascript',
			insertedProperty : 'textContent'
		}
	},

	embedTaistiePart: function(contentType, content) {
		var insertionParams = this.insertionParams[contentType]

		var toEmbed = this.doc.createElement(insertionParams.tagName);
		toEmbed.setAttribute('type', insertionParams.typeAttribute);
		toEmbed[insertionParams.insertedProperty] = content;

		this.appendTo.appendChild(toEmbed);
	}
}