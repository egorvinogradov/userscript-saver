Inheritance = {
	inherit: function(Child, Parent) {
		var childPrototypeBasis = function() { }
		childPrototypeBasis.prototype = Parent.prototype
		Child.prototype = new childPrototypeBasis()

		Child.prototype.constructor = Child
	}
}