describe('View', function() {
	it('gets DOM element from parent view by tag name', function() {
		var createChildArgs
		var view = new View()
		view._parentView = {
			createChildTag: function(tagName) {createChildArgs = tagName}
		}

		view.render('div')
		expect(createChildArgs).toEqual('div')
	})
})