describe('DependencyDispatcher', function() {
	var dependencyDispatcher
	beforeEach(function() {
		dependencyDispatcher = new DependencyDispatcher()
	})

	it('subscribes to dependency changes', function() {
		var dependency = {}
		var dependent = {}
		dependencyDispatcher.listen(dependency, dependent)
		expect(dependency._dependencyDispatcher).toBe(dependencyDispatcher)
		expect(dependency._dependents).toEqual([dependent])

		dependencyDispatcher.listen(dependency, dependent)
	})

	it('subscribes dependent to dependency only once', function() {
		var dependency = {}
		var dependent = {}
		dependencyDispatcher.listen(dependency, dependent)
		dependencyDispatcher.listen(dependency, dependent)
		expect(dependency._dependents).toEqual([dependent])
	})

	it('updates all dependents on dependency change', function() {
		var dependency = {change: function (){
			this._dependencyDispatcher.onDependencyChanged(this)
		}}

		var refreshedDependents = []
		var refreshMethod = function(){refreshedDependents.push(this)}
		var dependent1 = {refresh: refreshMethod}, dependent2 = {refresh: refreshMethod}

		dependencyDispatcher.listen(dependency, dependent1)
		dependencyDispatcher.listen(dependency, dependent2)

		dependency.change()

		expect(refreshedDependents).toEqual([dependent1, dependent2])
	})
})