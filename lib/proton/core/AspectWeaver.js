AspectWeaver = function(){}

AspectWeaver.prototype.getPrototype = function() {
	return this._constructorFunction.prototype
}

AspectWeaver.prototype.add = function(methodName, method) {
	//TODO: проверять, что метод задан
	this.getPrototype()[methodName] = method
}

AspectWeaver.prototype.after = function(methodName, newMethod) {
	var oldMethod = this.getPrototype()[methodName]

	//TODO: проверять, что старый метод существует
	this.getPrototype()[methodName] = function(arg) {
		var returnValue = oldMethod.apply(this, arguments)
		var newArguments = [returnValue]
		for(var oldArgumentsIndex = 0; oldArgumentsIndex < arguments.length; oldArgumentsIndex++) {
			newArguments.push(arguments[oldArgumentsIndex])
		}
		return newMethod.apply(this, newArguments)
	}
}