$(function() {

	var iocContainer = new IocContainer()
	iocContainer.setSchema({
		optionsRoot: {ctor: OptionsRoot, deps: {_newTaistieWidget: 'newTaistieWidget'}},
		newTaistieWidget: {ctor: NewTaistieWidget, deps: {_newTaistie: 'newTaistie'}},
		newTaistie: {ctor: Taistie}
	})

	var optionsRoot = iocContainer.getElement('optionsRoot')
	optionsRoot._element = $('body')

	optionsRoot.prerender()

	var newTaistie = iocContainer.getElement('newTaistie')
	newTaistie.setTaistieData({urlRegexp: '*'})

	var newTaistieWidget = iocContainer.getElement('newTaistieWidget')

	newTaistieWidget.fill()
})