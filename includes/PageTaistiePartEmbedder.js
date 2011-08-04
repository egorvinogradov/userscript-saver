function PageTaistiePartEmbedder(docInstance) {
	this.doc = docInstance
	this.appendTo = doc.querySelector('body')
}
PageTaistiePartEmbedder.prototype = {
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