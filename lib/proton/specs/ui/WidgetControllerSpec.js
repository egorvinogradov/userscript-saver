describe('WidgetController', function() {
	var controller
	beforeEach(function() {
		controller = new WidgetController()
	})

	it('listens to changes in models which its widget depends on', function() {
		var model1 = {}, model2 = {}, dependencies = []
		var widget = {
			getModelDepedencies: function() {
				return [model1, model2]
			}
		}

		controller._dependencyDispatcher = {
			listen: function(dependency, dependent) {
				dependencies.push({dependency: dependency, dependent: dependent})
			}
		}
		console.log(controller._dependencyDispatcher)

		controller.setWidget(widget)
		expect(controller._widget).toBe(widget)
		expect(dependencies).toEqual([
			{dependency: model1, dependent: controller},
			{dependency: model2, dependent: controller}
		])
	})

	it('refresh: if its widget wasn\'t prerendered, prerenders it, then fills it', function() {
		var prerenderCallsCount = 0, fillCallsCount = 0

		controller._widget = {
			prerender: function() {prerenderCallsCount++},
			fill: function() {fillCallsCount++}
		}

		controller._hasBeenPrerendered = true
		controller.refresh()
		expect(prerenderCallsCount).toEqual(0)
		expect(fillCallsCount).toEqual(1)

		controller._hasBeenPrerendered = false
		controller.refresh()
		expect(prerenderCallsCount).toEqual(1)
		expect(fillCallsCount).toEqual(2)
		expect(controller._hasBeenPrerendered).toEqual(true)
	})
})