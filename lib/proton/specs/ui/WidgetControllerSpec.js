describe('WidgetController', function() {
	var controller
	beforeEach(function() {
		controller = new WidgetController()
	})

	it('listens to changes in models which its widget depends on', function() {
		var model1 = {number: 1, _adviceAddDependent: listen},
			model2 = {number: 2, _adviceAddDependent: listen}, dependencies = []
		controller._widget = {
			getModelDepedencies: function() {
				return [model1, model2]
			}
		}

		function listen(dependent) {
				dependencies.push({number: this.number, dependent: dependent})
		}

		controller.init()
		expect(dependencies).toEqual([
			{number: 1, dependent: controller},
			{number: 2, dependent: controller}
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

	it('calls \'widget.prerender\' only if widget has such method', function() {
		controller._widget = {fill: function(){}}
		controller.refresh()
	})
})