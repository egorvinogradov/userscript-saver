CentralPageTaister = function(){};

//TODO: мб логику применения Taistie вынести в саму Taistie
CentralPageTaister.prototype.TaistTabUp = function(taisties, taistedTabId) {

	var requestTaistiePartEmbed = function(taistiePartType, taistiePartContent) {

		//TODO: работу с Хромом вынести в отдельную обертку API Хрома
		//TODO: работу с различными action так же инкапсулировать отдельно
		chrome.tabs.sendRequest(taistedTabId, {action: 'bundleReady', type: taistiePartType, body: taistiePartContent});
	};

	//TODO: мб вынести логику применения конкретной части в TaistiePart

	taisties.forEach(function(currentTaistie) {
		if ('LESS' in currentTaistie) {
			var lessParser = new (less.Parser);
			lessParser.parse(currentTaistie.LESS, function(err, tree) {
				if (err) {
					console.log(err)
				}
				else {
					requestTaistiePartEmbed('css', tree.toCSS());
				}
			})
		}

		if ('css' in currentTaistie) {
			requestTaistiePartEmbed('css', currentTaistie.css);
		}

		if ('jslib' in currentTaistie) {
			currentTaistie.jslib.forEach(function(lib) {
				requestTaistiePartEmbed(taistedTabId, 'jslib', lib);
			})
		}

		if ('js' in currentTaistie) {
			requestTaistiePartEmbed('js', currentTaistie.js);
		}
	})
};
