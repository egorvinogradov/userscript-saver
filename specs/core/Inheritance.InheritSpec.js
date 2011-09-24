describe("Inheritance", function() {
	describe("inherit", function() {
		it('inherits parent methods', function() {
			var Parent = function() {}
			Parent.prototype.parentMethod = function() {return 'parent method called!'}
			var Child = function() {}
			Inheritance.inherit(Child, Parent)

			expect(Child.prototype.parentMethod()).toEqual('parent method called!')
		})

		it('allows to use parent constructor by Child.__parentConstructor.apply(this, ...)', function() {
			var Parent = function() {
				this.parentCalled = true
			}
			var DisrespectfulChild = function(){}
			Inheritance.inherit(DisrespectfulChild, Parent)

			var disrespectful = new DisrespectfulChild()
			expect(disrespectful.parentCalled).toEqual(undefined)

			var RespectfulChild = function() {
				RespectfulChild.__parentConstructor.apply(this)
			}
			Inheritance.inherit(RespectfulChild, Parent)

			var respectful = new RespectfulChild()
			expect(respectful.parentCalled).toBeTruthy()
		})

		it('allows to use overriden parent methods by Child.__parentPrototype.*.apply(this, ...)', function() {
			var Parent = function() {}
			Parent.prototype.overridenMethod = function() {return 'Parent'}
			var Child = function() {}
			Inheritance.inherit(Child, Parent)
			Child.prototype.overridenMethod = function(){return Child.__parentPrototype.overridenMethod.apply(this) + '.Child'}

			expect(Child.prototype.overridenMethod()).toEqual('Parent.Child')
		})

		it('preserves correct \'constructor\' property', function() {
			var Child = function(){}
			Inheritance.inherit(Child, function(){})
			expect((new Child()).constructor).toEqual(Child)
		})
	})
})