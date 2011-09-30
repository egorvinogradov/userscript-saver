(function() {
	var taistiesStorage = new TaistiesStorage()
	var taistieCombiner = new TaistieCombiner()
	var taistieWrapper = new TaistieWrapper()
	var tabTaister = new TabTaister()

	taistieCombiner._dTaistiesStorage = taistiesStorage
	tabTaister._dTaistieCombiner = taistieCombiner
	tabTaister._dTaistieWrapper = taistieWrapper
	tabTaister._tabApi = TabApi

	tabTaister.startListeningToTabChange()
}())
