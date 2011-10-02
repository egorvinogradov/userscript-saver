describe('Widget', function() {
	var widget
	beforeEach(function() {
		widget = new Widget()
	})

	it('refresh: if it hasn\'t been prerendered, prerenders, then fills itself', function() {
		var prerenderCallsCount = 0, fillCallsCount = 0
		widget._prerender = function() {prerenderCallsCount++}
		widget.fill = function() {fillCallsCount++}

		widget._hasBeenPrerendered = true
		widget.refresh()
		expect(prerenderCallsCount).toEqual(0)
		expect(fillCallsCount).toEqual(1)

		widget._hasBeenPrerendered = false
		widget.refresh()
		expect(prerenderCallsCount).toEqual(1)
		expect(fillCallsCount).toEqual(2)
		expect(widget._hasBeenPrerendered).toEqual(true)
	})

	it('_prerender: creates custom UI (or connects to existing one) and inits child widgets', function() {
		var customUiCreated, initedChildren = []
		widget.createUi = function() {customUiCreated = true}
		widget.getChildWidgets = function() {
			var childWidget = {init: function(uiElement) {initedChildren.push(uiElement)}}
			return [
				{widget: childWidget, uiElement: 'foo'},
				{widget: childWidget, uiElement: 'bar'}
			]
		}

		widget._prerender()
		expect(customUiCreated).toEqual(true)
		expect(initedChildren).toEqual(['foo', 'bar'])
	})
})