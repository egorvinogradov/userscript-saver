DependencyDispatcher = function(){}

DependencyDispatcher.prototype.listen = function(dependency, dependent) {
	dependency._dependencyDispatcher = this
	if(dependency._dependents === undefined) {
		dependency._dependents = []
	}

	if(dependency._dependents.indexOf(dependent) == -1) {
		dependency._dependents.push(dependent)
	}
}