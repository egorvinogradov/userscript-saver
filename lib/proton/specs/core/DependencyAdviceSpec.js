describe('DependencyAdvice', function() {
	var dependencyDispatcher
	beforeEach(function() {
		dependencyDispatcher = new DependencyAdvice()
	})

	it('subscribes to dependency changes', function() {
		var dependent = {}
		dependencyDispatcher.listen(dependent)
		expect(dependencyDispatcher._dependents).toEqual([dependent])
	})

	it('subscribes dependent to dependency only once', function() {
		var dependent = {}
		dependencyDispatcher.listen(dependent)
		dependencyDispatcher.listen(dependent)
		expect(dependencyDispatcher._dependents).toEqual([dependent])
	})

	it('updates all dependents on dependency change', function() {
		var refreshedDependents = []
		var refreshMethod = function(){refreshedDependents.push(this)}
		var dependent1 = {refresh: refreshMethod}, dependent2 = {refresh: refreshMethod}

		dependencyDispatcher.listen(dependent1)
		dependencyDispatcher.listen(dependent2)

		dependencyDispatcher.onDependencyChanged()

		expect(refreshedDependents).toEqual([dependent1, dependent2])
	})
})