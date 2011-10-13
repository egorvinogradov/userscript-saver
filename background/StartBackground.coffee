do ->
	iocContainer = new IocContainer
	iocContainer.setSchema
		tabTaister:
			ctor: TabTaister
			deps:
				_dTaistieCombiner: 'taistieCombiner'
				_dTaistieWrapper: 'taistieWrapper'
				_tabApi: 'tabApi'
		taistieCombiner:
			ctor: TaistieCombiner,
			deps: _dTaistiesStorage: 'taistiesStorage'
		taistiesStorage: ctor: TaistiesStorage
		taistieWrapper: ctor: TaistieWrapper
		tabApi: ref: TabApi

	tabTaister = iocContainer.getElement 'tabTaister'
	tabTaister.startListeningToTabChange()
