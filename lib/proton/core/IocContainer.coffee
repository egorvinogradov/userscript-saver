class IocContainer extends IocContainerBare

do ->
	checker = new IocContainerContract
	checker.applyToIocContainerPrototype IocContainer
