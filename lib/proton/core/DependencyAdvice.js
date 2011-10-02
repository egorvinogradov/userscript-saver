DependencyAdvice = function() {}

DependencyAdvice.prototype.weave = function(adviceWeaver, listenedMethods){
	listenedMethods.forEach(function(listenedMethod){
		adviceWeaver.after(listenedMethod, this.onChange)
	}, this)

	adviceWeaver.add('addDependent', this.addDependent)
}

DependencyAdvice.prototype.addDependent = function(dependent) {
	if (this._dependents === undefined) {
		this._dependents = []
	}

	if (this._dependents.indexOf(dependent) == -1) {
		this._dependents.push(dependent)
	}
}

DependencyAdvice.prototype.onChange = function() {
	this._dependents.forEach(function(dependent) {
		dependent.refresh()
	})
}