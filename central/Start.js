(function() {
	var taistiesStorage = new TaistiesStorage()
	var taistieCombiner = new TaistieCombiner()
	var tabTaister = new TaistieWrapper()
	var tabListener = new TabListener()

	taistieCombiner.setTaistiesStorage(taistiesStorage)
	tabListener.setTaistieCombiner(taistieCombiner)
	tabListener.setTabTaister(tabTaister)

	tabListener.startListeningToTabChange()
}())
