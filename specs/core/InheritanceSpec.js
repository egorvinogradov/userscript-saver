describe("Inheritance", function() {
	describe("inherit", function() {
		it('inherits parent methods', function() {
			var Parent = function() {}
			Parent.prototype.name = function() {return 'Parent.foo'}
			var Child = function() {}
			Inheritance.inherit(Child, Parent)

			expect(Child.prototype.name()).toEqual('Parent.foo')
		})

		it('obliges to apply parent constructor directly', function() {
			var Parent = function() {
				this.parentCalled = true
			}
			var DisrespectfulChild = function(){}
			Inheritance.inherit(DisrespectfulChild, Parent)

			var disrespectful = new DisrespectfulChild()
			expect(disrespectful.parentCalled).toEqual(undefined)

			var RespectfulChild = function() {
				Parent.apply(this)
			}
			Inheritance.inherit(RespectfulChild, Parent)

			var respectful = new RespectfulChild()
			expect(respectful.parentCalled).toBeTruthy()
		})

		it('obliges to use overriden parent methods by apllying them directly', function() {
			var Parent = function() {}
			Parent.prototype.name = function() {return 'Parent'}
			var Child = function() {}
			Inheritance.inherit(Child, Parent)
			Child.prototype.name = function(){return Parent.prototype.name.apply(this) + '.Child'}

			expect(Child.prototype.name()).toEqual('Parent.Child')
		})

	})
})