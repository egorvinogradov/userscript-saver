class TaistiesStorage
	constructor: -> @_allTaisties = null

	getAllTaisties: ->
		if @_allTaisties is null
			@_allTaisties = []

			#for the beginning store all taisties in the code
			allTaistiesData = []

			allTaistiesData.push @_developedTaistie

			allTaistiesData.forEach (taistieData) =>
				taistie = new Taistie
				taistie.setTaistieData taistieData
				@_allTaisties.push taistie

		return @_allTaisties

