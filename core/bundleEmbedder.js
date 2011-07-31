function processBundles(bundles, embedTo) {
	bundles.forEach(function(bundle) {
		if ('LESS' in bundle) {
			var lessParser = new (less.Parser)
			lessParser.parse(bundle.LESS, function(err, tree) {
				if (err) {
					console.log(err)
				}
				else {
					chrome.tabs.sendRequest(embedTo, {action: 'bundleReady', type: 'css', body: tree.toCSS()})
				}
			})
		}

		if ('css' in bundle) {
			chrome.tabs.sendRequest(embedTo, {action: 'bundleReady', type: 'css', body: bundle.css})
		}

		if ('jslib' in bundle) {
			bundle.jslib.forEach(function(lib) {
				chrome.tabs.sendRequest(embedTo, {action: 'bundleReady', type: 'jslib', body: lib})
			})
		}

		if ('js' in bundle) {
			chrome.tabs.sendRequest(embedTo, {action: 'bundleReady', type: 'js', body: bundle.js})
		}
	})
}