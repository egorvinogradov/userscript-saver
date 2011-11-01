$ ->
	iocContainer = new IocContainer
	iocContainer.setSchema
		taistieWidgetFactoryFunction:
			factoryFunction: TaistieWidget
			deps:
				_newPlainDomControl: 'plainDomControlFactoryFunction'
		plainDomControlFactoryFunction:
			factoryFunction: PlainDomControl

	taistieListWidget = new TaistieListWidget el: $("#tasks")
	taistieListWidget._newtaistieWidget = iocContainer.getElement 'taistieWidgetFactoryFunction'
	taistieListWidget.start()
