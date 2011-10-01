describe('Widget', function() {
	var widget
	beforeEach(function() {
		widget = new Widget()
	})
	it('during initialization stores its DOM element and subscribes to its show/hide event using given UI API', function() {
		var uiApi = {subscribeOnShow: function(elem, wdg){
			this.subscriptionArgs = {uiElement: elem, widget: wdg}
		}}
		widget._uiApi = uiApi

		var uiElement = {}
		widget.init(uiElement)
		expect(widget._uiElement).toBe(uiElement)
		expect(uiApi.subscriptionArgs).toEqual({uiElement: uiElement, widget: widget})
	})

	it('render: if hasn\'t been prerendered, prerenders, than fills itself', function(){
		var prerenderCallsCount = 0, fillCallsCount = 0
		widget._prerender = function() {prerenderCallsCount++}
		widget.fill = function(){fillCallsCount++}

		widget._hasBeenPrerendered  = true
		widget.refresh()
		expect(prerenderCallsCount).toEqual(0)
		expect(fillCallsCount).toEqual(1)

		widget._hasBeenPrerendered = false
		widget.refresh()
		expect(prerenderCallsCount).toEqual(1)
		expect(fillCallsCount).toEqual(2)
		expect(widget._hasBeenPrerendered).toEqual(true)
	})
})