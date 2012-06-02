$ ->
	iocContainer = new IocContainer
	iocContainer.setSchema
		taistieCollection:
			ref: Taistie
			deps:
				_userscriptsDownloader: 'userscriptsDownloader'
		userscriptsDownloader:
			single: UserscriptsDownloader
			deps:
				_ajaxProvider: 'jqueryAjaxProvider'
		jqueryAjaxProvider:
			single: JqueryAjaxProvider
		taistieListConstructor:
			ref: TaistieList
		tabApi:
			ref: TabApi

	Taistie.deleteAll()

	#TODO: добавить инициализацию зависимостей через IoC:
	# получать taistieList прямо из контейнера
	# taistieCollection проставлять как зависимость
	# для этого научить IoC передавать зависимости через параметры конструктора
	taistieListConstructor = iocContainer.getInstance 'taistieListConstructor'
	tabApi = iocContainer.getInstance 'tabApi'

	tabApi.getCurrentUrl (url) ->
		taistieList = new taistieListConstructor($(".taisties"), url, iocContainer.getInstance 'taistieCollection')
