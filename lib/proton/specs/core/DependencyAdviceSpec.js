describe('DependencyAdvice', function() {
	var dependencyAdvice
	beforeEach(function() {
		dependencyAdvice = new DependencyAdvice()
	})

	it('listens to changes in all given methods and adds method .addDependent', function() {
		var afteredMethods = [], addedMethod = {}
		var weaver = {
			after: function(methodName, method) {
				var afteredMethod = {}
				afteredMethod[methodName] = method
				afteredMethods.push(afteredMethod)
			},
			add: function(addedMethodName, method){addedMethod[addedMethodName] = method }
		}
		dependencyAdvice.weave(weaver, ['method1', 'method2'])
		expect(afteredMethods).toEqual([
			{method1: dependencyAdvice.onChange},
			{method2: dependencyAdvice.onChange}
		])

		expect(addedMethod).toEqual({'addDependent': dependencyAdvice.addDependent})
	})

	it('subscribes to dependency changes', function() {
		var dependent = {}
		dependencyAdvice.addDependent(dependent)
		expect(dependencyAdvice._dependents).toEqual([dependent])
	})

	it('subscribes dependent to dependency only once', function() {
		var dependent = {}
		dependencyAdvice.addDependent(dependent)
		dependencyAdvice.addDependent(dependent)
		expect(dependencyAdvice._dependents).toEqual([dependent])
	})

	it('updates all dependents on dependency change', function() {
		var refreshedDependents = []
		var refreshMethod = function(){refreshedDependents.push(this)}
		var dependent1 = {refresh: refreshMethod}, dependent2 = {refresh: refreshMethod}

		dependencyAdvice.addDependent(dependent1)
		dependencyAdvice.addDependent(dependent2)

		dependencyAdvice.onChange()

		expect(refreshedDependents).toEqual([dependent1, dependent2])
	})
})