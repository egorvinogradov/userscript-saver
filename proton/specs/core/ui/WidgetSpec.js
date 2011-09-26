describe('Widget', function() {
	it('delegates rendering to concrete view element with own parameters', function() {
		var renderArgs
		var widget = new Widget()
		widget._view = {
			render: function(parentView){renderArgs = parentView}
		}
		var parentView = {}
		widget.render(parentView)

		expect(renderArgs).toBe(parentView)

	})
})