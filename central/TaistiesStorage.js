function TaistiesStorage() {
	this._allTaisties = null
}

TaistiesStorage.prototype.getAllTaisties = function () {

	if (this._allTaisties === null) {
		this._allTaisties = []

		//for the beginning store all taisties in the code
		var allTaistiesData = []

		//include locally developed function
		if (DevelopedTaistie.use) {
			allTaistiesData.push(DevelopedTaistie.developedTaistieData)
		}

		var allTaisties = this._allTaisties

		allTaistiesData.forEach(function(taistieData){
			var taistie = new Taistie(taistieData)
			allTaisties.push(taistie)
		})
	}

	return this._allTaisties
}
