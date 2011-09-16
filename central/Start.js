(function() {
	var taistiesStorage = new TaistiesStorage()
	var taistieCombiner = new TaistieCombiner()
	var tabTaister = new TaistieWrapper()
	var tabListener = new TabTaister()

	taistieCombiner.setTaistiesStorage(taistiesStorage)
	tabListener.setTaistieCombiner(taistieCombiner)
	tabListener.setTaistieWrapper(tabTaister)

	tabListener.startListeningToTabChange()
}())
