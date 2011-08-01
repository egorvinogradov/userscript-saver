function insertTaistiesToPage(taisties, pageToInsertTaisties) {
	taisties.forEach(function(currentTaistie) {
		if ('LESS' in currentTaistie) {
			var lessParser = new (less.Parser)
			lessParser.parse(currentTaistie.LESS, function(err, tree) {
				if (err) {
					console.log(err)
				}
				else {
					chrome.tabs.sendRequest(pageToInsertTaisties, {action: 'bundleReady', type: 'css', body: tree.toCSS()})
				}
			})
		}

		if ('css' in currentTaistie) {
			chrome.tabs.sendRequest(pageToInsertTaisties, {action: 'bundleReady', type: 'css', body: currentTaistie.css})
		}

		if ('jslib' in currentTaistie) {
			currentTaistie.jslib.forEach(function(lib) {
				chrome.tabs.sendRequest(pageToInsertTaisties, {action: 'bundleReady', type: 'jslib', body: lib})
			})
		}

		if ('js' in currentTaistie) {
			chrome.tabs.sendRequest(pageToInsertTaisties, {action: 'bundleReady', type: 'js', body: currentTaistie.js})
		}
	})
}
