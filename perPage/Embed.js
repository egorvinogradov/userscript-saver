var Taist = {};

Taist.Embed = (function() {

	var contentTypeInsertionParameters = {
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
	};

	function insert(doc, contentType, content) {

		var insertionParameters = contentTypeInsertionParameters[contentType];

		var toEmbed = doc.createElement(insertionParameters.tagName);
		toEmbed.setAttribute('type', insertionParameters.typeAttribute);
		toEmbed[insertionParameters.insertedProperty] = content;
		doc.querySelector('body').appendChild(toEmbed)
	}

	return insert;
})();
