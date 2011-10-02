$(function() {

	var iocContainer = new IocContainer()
	iocContainer.setSchema({
		optionsRoot: {ctor: OptionsRoot, deps: {_newTaistieWidget: 'newTaistieWidget'}},
		newTaistieWidget: {ctor: NewTaistieWidget, deps: {_newTaistie: 'newTaistie'}},
		newTaistie: {ctor: Taistie},
		controller: {ctor: WidgetController, deps: {_widget: 'newTaistieWidget',
			_dependencyDispatcher: 'dependencyDispatcher'
		}},
		dependencyDispatcher: {ctor: DependencyDispatcherAdvice}
	})

	var optionsRoot = iocContainer.getElement('optionsRoot')
	optionsRoot._element = $('body')

	optionsRoot.prerender()

	var controller = iocContainer.getElement('controller')
	controller.init()

	var newTaistie = iocContainer.getElement('newTaistie')

	newTaistie.setTaistieDataAndChange = function(taistieData){
		this.setTaistieData(taistieData)
		this._dependencyDispatcher.onDependencyChanged(this)
	}

	newTaistie.setTaistieDataAndChange({urlRegexp: '*'})
})