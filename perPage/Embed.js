var Taist = {};

Taist.Embed = (function() {
	function insert(doc, elem) {
		doc.querySelector('body').appendChild(elem)
	}

	function insertCSS(doc, stylesheet) {
		var toEmbed = doc.createElement('style')
		toEmbed.setAttribute('type', 'text/css')
		toEmbed.textContent = stylesheet

		// guarantee that our styles will override
		insert(doc, toEmbed)
	}

	function insertJS(doc, script) {
		var toEmbed = doc.createElement('script')
		toEmbed.setAttribute('type', 'text/javascript')
		toEmbed.textContent = script

		insert(doc, toEmbed)
	}

	function insertJSLib(doc, path) {
		var toEmbed = doc.createElement('script')
		toEmbed.setAttribute('type', 'text/javascript')
		toEmbed.src = path

		insert(doc, toEmbed)
	}

	return {
		css: insertCSS,
		js: insertJS,
		jslib: insertJSLib
	}
})();
