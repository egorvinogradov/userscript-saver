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
			{method1: dependencyAdvice._adviceOnChange},
			{method2: dependencyAdvice._adviceOnChange}
		])

		expect(addedMethod).toEqual({_adviceAddDependent: dependencyAdvice._adviceAddDependent})
	})

	it('subscribes to dependency changes', function() {
		var dependent = {}
		dependencyAdvice._adviceAddDependent(dependent)
		expect(dependencyAdvice._adviceDependents).toEqual([dependent])
	})

	it('subscribes dependent to dependency only once', function() {
		var dependent = {}
		dependencyAdvice._adviceAddDependent(dependent)
		dependencyAdvice._adviceAddDependent(dependent)
		expect(dependencyAdvice._adviceDependents).toEqual([dependent])
	})

	it('updates all dependents on dependency change', function() {
		var refreshedDependents = []
		var refreshMethod = function(){refreshedDependents.push(this)}
		var dependent1 = {refresh: refreshMethod}, dependent2 = {refresh: refreshMethod}

		dependencyAdvice._adviceAddDependent(dependent1)
		dependencyAdvice._adviceAddDependent(dependent2)

		dependencyAdvice._adviceOnChange()

		expect(refreshedDependents).toEqual([dependent1, dependent2])
	})
})