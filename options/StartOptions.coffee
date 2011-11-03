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
				_taistieRepository: 'taistieRepository'
		taistieListTemplateAccessor:
			#TODO: сделать класс для templateAccessor
			ref: getDomFromTemplateByClass: -> $("#tasks")
		taistieRepository:
			ref: Taistie

	#TODO: убрать наследование от Controller
	taistieListWidget = iocContainer.getElement 'taistieListWidget'
	taistieListWidget.render()

