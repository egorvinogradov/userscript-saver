DependencyAdvice = function() {}

DependencyAdvice.prototype.weave = function(adviceWeaver, listenedMethods){
	listenedMethods.forEach(function(listenedMethod){
		adviceWeaver.after(listenedMethod, this._adviceOnChange)
	}, this)

	adviceWeaver.add('_adviceAddDependent', this._adviceAddDependent)
}

DependencyAdvice.prototype._adviceAddDependent = function(dependent) {
	if (this._adviceDependents === undefined) {
		this._adviceDependents = []
	}

	if (this._adviceDependents.indexOf(dependent) == -1) {
		this._adviceDependents.push(dependent)
	}
}

DependencyAdvice.prototype._adviceOnChange = function() {
	this._adviceDependents.forEach(function(dependent) {
		dependent.refresh()
	})
}