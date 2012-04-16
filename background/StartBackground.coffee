do ->
	iocContainer = new IocContainer
	iocContainer.setSchema
		tabTaister:
			single: TabTaister
			deps:
				_dTaistieCombiner: 'taistieCombiner'
				_dTaistieWrapper: 'taistieWrapper'
				_tabApi: 'tabApi'
				_popupIconPaths: 'popupIconPaths'
		taistieCombiner:
			single: TaistieCombiner
		taistieWrapper:
			single: TaistieWrapper
		tabApi:
			ref: TabApi
		popupIconPaths:
			ref:
				enabled: '../icons/browser_action_taistie_enabled.png'
				disabled: '../icons/browser_action_taistie_disabled.png'


	tabTaister = iocContainer.getElement 'tabTaister'
	tabTaister.startListeningToTabChange()
