(function() {
	var taistiesStorage = new TaistiesStorage()
	var taistieCombiner = new TaistieCombiner()
	var tabTaister = new TabTaister()

	taistieCombiner.setTaistiesStorage(taistiesStorage)

	tabTaister.setTaistieCombiner(taistieCombiner)
	tabTaister.setTabApi(TabApi)

	tabTaister.startListeningToTabChange()
}())
