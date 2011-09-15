(function() {
	var taistiesStorage = new TaistiesStorage()
	var pageTaistier = new TaistieCombiner()

	pageTaistier.setTaistiesStorage(taistiesStorage)

	TabApi.subscribeToTabChange(function(tabUrl, tabDescriptor){
		var allTaistiesCode = pageTaistier.getAllCssAndJsForUrl(tabUrl)
		TabApi.insertJsToTab(allTaistiesCode, tabDescriptor)
	})
}())
