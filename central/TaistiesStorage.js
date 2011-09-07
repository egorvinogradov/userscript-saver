function CentralTaistiesStorage() {
}

CentralTaistiesStorage.prototype.getAllTaisties = function () {

	if (this._allTaisties === undefined) {
		this._allTaisties = []

		//for the beginning store all taisties in the code
		var allTaistiesData = []

		//include locally developed function
		var developedTaistieData = getDevelopedTaistieData();
		allTaistiesData.push(developedTaistieData);

		var allTaisties = this._allTaisties;

		allTaistiesData.forEach(function(taistieData){
			var taistie = new Taistie(taistieData)
			allTaisties.push(taistie)
		})
	}

	return this._allTaisties
};
