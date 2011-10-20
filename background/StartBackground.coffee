do ->
	iocContainer = new IocContainer
	iocContainer.setSchema
		tabTaister:
			ctor: TabTaister
			deps:
				_dTaistieCombiner: 'taistieCombiner'
				_dTaistieWrapper: 'taistieWrapper'
				_tabApi: 'tabApi'
				_popupResourcePaths: 'popupResourcePaths'
		taistieCombiner:
			ctor: TaistieCombiner
			deps: _dTaistiesStorage: 'taistiesStorage'
		taistiesStorage:
			ctor: TaistiesStorage
		taistieWrapper:
			ctor: TaistieWrapper
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
