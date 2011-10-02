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

	var newTaistieWidget = iocContainer.getElement('newTaistieWidget')
	var controller = new WidgetController()
	controller.setWidget(newTaistieWidget)

	var newTaistie = iocContainer.getElement('newTaistie')
	newTaistie.setTaistieData({urlRegexp: '*'})

	newTaistieWidget.fill()
})