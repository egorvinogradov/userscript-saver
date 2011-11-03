$ ->
	iocContainer = new IocContainer
	iocContainer.setSchema
		taistieWidgetFactoryFunction:
			factoryFunction: TaistieWidget
			deps:
				_newPlainDomControl: 'plainDomControlFactoryFunction'
		plainDomControlFactoryFunction:
			factoryFunction: PlainDomControl

	#TODO: DI; убрать наследование от Controller
	taistieListWidget = new TaistieListWidget
	taistieListWidget._templateAccessor =
		getDomFromTemplateByClass: -> $("#tasks")
	taistieListWidget._newTaistieWidget = iocContainer.getElement 'taistieWidgetFactoryFunction'
	taistieListWidget._newPlainDomControl = iocContainer.getElement 'plainDomControlFactoryFunction'
	taistieListWidget.render()
	window.taistieListWidget = taistieListWidget
