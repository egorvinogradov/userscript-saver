$ ->
	iocContainer = new IocContainer
	iocContainer.setSchema
		taistieWidgetFactoryFunction:
			factoryFunction: TaistieWidget
			deps:
				_newPlainDomControl: 'plainDomControlFactoryFunction'
		plainDomControlFactoryFunction:
			factoryFunction: PlainDomControl
		taistieListWidget:
			single: TaistieListWidget
			deps:
				_templateAccessor: 'taistieListTemplateAccessor'
				_newTaistieWidget: 'taistieWidgetFactoryFunction'
				_newPlainDomControl: 'plainDomControlFactoryFunction'
		taistieListTemplateAccessor:
			#TODO: сделать класс для templateAccessor
			ref: getDomFromTemplateByClass: -> $("#tasks")

	#TODO: убрать наследование от Controller
	taistieListWidget = iocContainer.getElement 'taistieListWidget'
	taistieListWidget.render()

