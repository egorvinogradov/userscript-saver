class IocContainer extends IocContainerBare

do ->
	checker = new IocContainerChecker
	checker.applyToIocContainerPrototype IocContainer
