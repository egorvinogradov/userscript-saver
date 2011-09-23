describe("Inheritance", function() {
	describe("inherit", function() {
		it('inherits parent methods', function() {
			var parent = function(){}
			parent.prototype.foo = function(){return 'foo'}

			var child = function(){}
			Inheritance.inherit(child, parent)

			expect(child.prototype.foo).toBeDefined()
		})
	})
})