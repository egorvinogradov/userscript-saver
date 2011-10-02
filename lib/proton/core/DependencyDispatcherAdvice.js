DependencyDispatcherAdvice = function() {}

DependencyDispatcherAdvice.prototype.execute = function(adviceAdder, changeableMethods){
	changeableMethods.forEach(function(changeableMethod){
		adviceAdder.after(changeableMethod, this.onDependencyChanged)
	})

	adviceAdder.add('listen', this.listen)
}

DependencyDispatcherAdvice.prototype.listen = function(dependent) {
	if (this._dependents === undefined) {
		this._dependents = []
	}

	if (this._dependents.indexOf(dependent) == -1) {
		this._dependents.push(dependent)
	}
}

DependencyDispatcherAdvice.prototype.onDependencyChanged = function() {
	this._dependents.forEach(function(dependent) {
		dependent.refresh()
	})
}