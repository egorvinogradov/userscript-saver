AspectWeaver = function(){}

AspectWeaver.prototype.getPrototype = function() {
	return this._constructorFunction.prototype
}

AspectWeaver.prototype.add = function(OrPropertyName, methodOrProperty) {
	this.getPrototype()[OrPropertyName] = methodOrProperty
}

AspectWeaver.prototype.after = function(methodName, newMethod) {
	var oldMethod = this.getPrototype()[methodName]

	//TODO: проверять, что старый метод существует, и оба - методы
	this.getPrototype()[methodName] = function() {
		var returnValue = oldMethod.apply(this, arguments)
		var newArguments = [returnValue]
		for(var oldArgumentsIndex = 0; oldArgumentsIndex < arguments.length; oldArgumentsIndex++) {
			newArguments.push(arguments[oldArgumentsIndex])
		}
		return newMethod.apply(this, newArguments)
	}
}

AspectWeaver.prototype.before = function(methodName, newMethod) {
	var oldMethod = this.getPrototype()[methodName]

	//TODO: проверять, что старый метод существует, и оба - методы
	this.getPrototype()[methodName] = function() {
		newMethod.apply(this, arguments)
		return oldMethod.apply(this, arguments)
	}
}