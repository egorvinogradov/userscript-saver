describe('WidgetController', function() {
	var controller
	beforeEach(function() {
		controller = new WidgetController()
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

	it('_prerender: creates custom UI (or connects to existing one) and inits child widgets', function() {
		var customUiCreated, initedChildren = []
		controller.createUi = function() {customUiCreated = true}
		controller.getChildWidgets = function() {
			var childWidget = {init: function(uiElement) {initedChildren.push(uiElement)}}
			return [
				{widget: childWidget, uiElement: 'foo'},
				{widget: childWidget, uiElement: 'bar'}
			]
		}

		controller._prerender()
		expect(customUiCreated).toEqual(true)
		expect(initedChildren).toEqual(['foo', 'bar'])
	})
})