var Taist = {};

Taist.Embed = (function() {
	function insert(doc, content, contentTagName, contentType, contentInsertionAttribute) {
		var toEmbed = doc.createElement(contentTagName)
		toEmbed.setAttribute('type', contentType)
		toEmbed[contentInsertionAttribute] = content
		doc.querySelector('body').appendChild(toEmbed)
	}
	
	function insertCSS(doc, stylesheet) {
		insert(doc, stylesheet, 'style', 'text/css', 'textContent')
	}

	function insertJS(doc, script) {
		insert(doc, script, 'script', 'text/javascript', 'textContent')
	}

	function insertJSLib(doc, path) {
		insert(doc, path, 'script', 'text/javascript', 'src')
	}

	return {
		css: insertCSS,
		js: insertJS,
		jslib: insertJSLib
	}
})();