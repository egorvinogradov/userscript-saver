describe('Widget', function() {
	it('delegates rendering to concrete view element with own parameters', function() {
		var renderArgs
		var widget = new Widget()
		widget._view = {
			render: function(parentElement){renderArgs = parentElement}
		}
		var parentElement = {}
		widget.render(parentElement)

		expect(renderArgs).toBe(parentElement)
	})
})