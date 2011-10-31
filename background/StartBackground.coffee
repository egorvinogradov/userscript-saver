do ->
	iocContainer = new IocContainer
	iocContainer.setSchema
		tabTaister:
			singleton: TabTaister
			deps:
				_dTaistieCombiner: 'taistieCombiner'
				_dTaistieWrapper: 'taistieWrapper'
				_tabApi: 'tabApi'
				_popupResourcePaths: 'popupResourcePaths'
		taistieCombiner:
			singleton: TaistieCombiner
			deps: _dTaistiesStorage: 'taistiesStorage'
		taistiesStorage:
			singleton: TaistiesStorage
			deps:
				_developedTaistie: 'developedTaistie'
		developedTaistie:
			ref: DevelopedTaistie
		taistieWrapper:
			singleton: TaistieWrapper
		tabApi:
			ref: TabApi
		popupResourcePaths:
			ref:
				enabled:
					icon: '../icons/browser_action_taistie_enabled.png'
					page: '../popup/popup.html'
				disabled:
					icon: '../icons/browser_action_taistie_disabled.png'
					page: ''


	tabTaister = iocContainer.getElement 'tabTaister'
	tabTaister.startListeningToTabChange()
