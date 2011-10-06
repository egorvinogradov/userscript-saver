IocAopContainer = function() {
	IocContainer.call(this)
}

Inheritance.inherit(IocAopContainer, IocContainer)

IocAopContainer.prototype._createFromConstructor = function(ctor) {
	return IocContainer.prototype._createFromConstructor.call(this, ctor)
}