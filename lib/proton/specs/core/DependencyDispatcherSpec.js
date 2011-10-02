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
})