describe('JqueryView', function() {
	it('creates own element by tag name and appends it to parent element', function() {
		var appendedElement
		var createdElement = {}

		var view = new JqueryView()
		view._jqueryFunction = function(tag){
			createdElement = {tag: tag}
			return createdElement
		}
		view._tagName = 'div'
		var parentElement= {append: function(args){appendedElement = args}}

		view.render(parentElement)
		expect(createdElement).toEqual({tag: '<div/>'})
		expect(view._element).toBe(createdElement)
		expect(appendedElement).toBe(createdElement)
	})
})