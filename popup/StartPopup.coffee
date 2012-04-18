$ ->
	iocContainer = new IocContainer
	iocContainer.setSchema
		taistie:
			ref: Taistie
			deps:
				_userscriptsDownloader: 'userscriptsDownloader'
		userscriptsDownloader:
			ref: UserscriptsDownloader
		taistieListConstructor:
			ref: TaistieList

	taistieListConstructor = iocContainer.getElement 'taistieListConstructor'

	#TODO: добавить инициализацию зависимостей через IoC
	new taistieListConstructor(el: $("#tasks"))
