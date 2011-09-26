describe('Widget', function() {
	it('delegates rendering to concrete view element with own parameters', function() {
		var renderArgs
		var widget = new Widget()
		widget._additionalOptions = {additionalOption: 'foo'}
		widget._tagName = 'div'
		widget._view = {
			render: function(tagName, additionalOptions){renderArgs = {tagName: tagName,
				additionalOptions: additionalOptions}}
		}

		widget.render()

		expect(renderArgs).toEqual({tagName: 'div', additionalOptions: {additionalOption: 'foo'}})

	})
})