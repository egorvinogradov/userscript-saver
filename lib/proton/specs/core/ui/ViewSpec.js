describe('View', function() {
	it('creates own UI element by tag name and appends it to parent UI element', function() {
		var createChildArgs
		var view = new View()
		view._tagName = 'div'
		var parentView = {
			createChildElement: function(tagName) {createChildArgs = tagName}
		}

		view.render(parentView)
		expect(createChildArgs).toEqual('div')
	})

	it('creates child UI element as jquery child of own UI element', function() {
		var view = new View()
		var jqueryFunctionArgs
		var createdChildElement = {}
		var appendedArgs

		view._jqueryFunction = function(args){
			jqueryFunctionArgs = args
			return createdChildElement
		}
		view._element = {append: function(args){appendedArgs = args}}

		var result = view.createChildElement('div')
		expect(jqueryFunctionArgs).toEqual('<div/>')
		expect(appendedArgs).toBe(createdChildElement)
		expect(result).toBe(createdChildElement)

	})
})