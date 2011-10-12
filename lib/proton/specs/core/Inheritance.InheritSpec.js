describe("Inheritance", function() {
	describe("inherit", function() {
		it('inherits parent methods', function() {
			var Parent = function() {}
			Parent.prototype.parentMethod = function() {return 'parent method called!'}
			var Child = function() {}
			Inheritance.inherit(Child, Parent)

			expect(Child.prototype.parentMethod()).toEqual('parent method called!')
		})

		it('preserves correct \'constructor\' property', function() {
			var Child = function(){}
			Inheritance.inherit(Child, function(){})
			expect((new Child()).constructor).toEqual(Child)
		})
	})
})