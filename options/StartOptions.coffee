$ ->
	iocContainer = new IocContainer
	iocContainer.setSchema
		taistieWidgetFactoryFunction:
			factoryFunction: TaistieWidget

	taistieListWidget = new TaistieListWidget el: $("#tasks")
	taistieListWidget._newtaistieWidget = iocContainer.getElement 'taistieWidgetFactoryFunction'
	taistieListWidget.start()
