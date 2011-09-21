(function() {
	var taistiesStorage = new TaistiesStorage()
	var taistieCombiner = new TaistieCombiner()
	var tabTaister = new TaistieWrapper()
	var tabListener = new TabTaister()

	taistieCombiner._dTaistiesStorage = taistiesStorage
	tabListener._dTaistieCombiner = taistieCombiner
	tabListener._dTaistieWrapper = tabTaister

	tabListener.startListeningToTabChange()
}())
