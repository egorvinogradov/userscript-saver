$ ->

	#заглушки для независимого создания UI userscript'ов
	mockTargetSiteUrl = 'http://mocktarget.com'
	mockTaisties = [
		{
			name: 'My super decorator'
			active: true
			rootUrl: mockTargetSiteUrl
			css: ''
			js: 'alert(\'decorated!\')'
			source: 'own'
			externalId: ''
			description: 'My super-fancy forbes decorator'
			usageCount: 0
		},
		{
			name: 'My UX enhancer'
			active: true
			rootUrl: mockTargetSiteUrl
			css: ''
			js: 'alert(\'UX enhanced!\')'
			source: 'own'
			externalId: ''
			description: 'Replaces all UI with one button \'Make me happy\'. And it works!'
			usageCount: 0
		},
		{
			name: 'My habr accelerator'
			active: true
			rootUrl: 'habrahabr.ru'
			css: ''
			js: 'alert(\'habr accelerated!\')'
			source: 'own'
			externalId: ''
			description: 'Habrahabr get speed of the light'
			usageCount: 0
		},
		{
			name: 'US 1'
			active: false
			rootUrl: mockTargetSiteUrl
			css: ''
			js: 'alert(\'userscript1\')'
			source: 'userscripts'
			externalId: 1
			description: 'Userscript # 1. Makes you really happy - boosts internet, increases appetite, cures headache. Some additional description goes here: bla-bla-bla-bla'
			usageCount: 500
		},
		{
			name: 'US 2'
			active: true
			rootUrl: mockTargetSiteUrl
			css: ''
			js: 'alert(\'userscript 2\')'
			source: 'userscripts'
			externalId: 1
			description: 'Userscript # 2. Makes you really happy - boosts internet, increases appetite, cures headache. Some additional description goes here: bla-bla-bla-bla'
			usageCount: 400
		},
		{
			name: 'US 3'
			active: true
			rootUrl: mockTargetSiteUrl
			css: ''
			js: 'alert(\'userscript 3\')'
			source: 'userscripts'
			externalId: 1
			description: 'Userscript # 3. Makes you really happy - boosts internet, increases appetite, cures headache. Some additional description goes here: bla-bla-bla-bla'
			usageCount: 300
		},
		{
			name: 'US 4'
			active: false
			rootUrl: mockTargetSiteUrl
			css: ''
			js: 'alert(\'userscript 4\')'
			source: 'userscripts'
			externalId: 1
			description: 'Userscript # 4. Makes you really happy - boosts internet, increases appetite, cures headache. Some additional description goes here: bla-bla-bla-bla'
			usageCount: 200
		},
		{
			name: 'US 5'
			active: false
			rootUrl: mockTargetSiteUrl
			css: ''
			js: 'alert(\'userscript 5\')'
			source: 'userscripts'
			externalId: 1
			description: 'Userscript # 5. Makes you really happy - boosts internet, increases appetite, cures headache. Some additional description goes here: bla-bla-bla-bla'
			usageCount: 100
		}
	]

	Taistie.deleteAll()
	Taistie.create mockTaistieData for mockTaistieData in mockTaisties

	mockUserscriptsDownloader =
		getUserscriptsForUrl: -> []

	iocContainer = new IocContainer
	iocContainer.setSchema
		taistieCollection:
			ref: Taistie
			deps:
				_userscriptsDownloader: 'userscriptsDownloader'
		userscriptsDownloader:
			ref: mockUserscriptsDownloader
		taistieListConstructor:
			ref: TaistieList

	#TODO: добавить инициализацию зависимостей через IoC:
	# получать taistieList прямо из контейнера
	# taistieCollection проставлять как зависимость
	# для этого научить IoC передавать зависимости через параметры конструктора
	taistieListConstructor = iocContainer.getElement 'taistieListConstructor'

	taistieList = new taistieListConstructor($("#tasks"), mockTargetSiteUrl, iocContainer.getElement 'taistieCollection')
