$(function() {

	var iocContainer = new IocContainer()
	iocContainer.setSchema({
		optionsRoot: {ctor: OptionsRoot, deps: {_newTaistieWidget: 'newTaistieWidget'}},
		newTaistieWidget: {ctor: NewTaistieWidget, deps: {_newTaistie: 'newTaistie'}},
		newTaistie: {ctor: Taistie},
		controller: {ctor: WidgetController, deps: {_widget: 'newTaistieWidget'}}
	})

	var dependencyAdvice = new DependencyAspect()
	var aspectWeaver = new AspectWeaver()
	aspectWeaver._constructorFunction = Taistie
	dependencyAdvice.weave(aspectWeaver, ['setTaistieData'])

	var optionsRoot = iocContainer.getElement('optionsRoot')

	//TODO: вынести в RootWidget
	optionsRoot._element = $('body')

	optionsRoot.prerender()

	var controller = iocContainer.getElement('controller')
	controller.init()

	var newTaistie = iocContainer.getElement('newTaistie')

	newTaistie.setTaistieData({urlRegexp: '*'})
})