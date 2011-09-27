describe('IocContainer', function() {
	var iocContainer

	beforeEach(function() {
		iocContainer = new IocContainer()
	})
	it('creates new object if its constructor given in \'ctor\'', function() {
		var Foo = function(){this.name = 'foo'}
		iocContainer.setSchema({
			fooInstance: {ctor: Foo}
		})

		expect(iocContainer.getElement('fooInstance')).toEqual(new Foo())
	})

	it('gets existing object if its reference given in \'reference\'', function() {
		var foo = {name: 'fooElement'}
		iocContainer.setSchema({
			fooInstance: {
				reference: foo
			}
		})

		expect(iocContainer.getElement('fooInstance')).toBe(foo)
	})

	it('checks that schema is set and contains element', function() {

		var getFoo = function(){iocContainer.getElement('fooInstance')}
		expect(getFoo).toThrow('Dependency schema is not set')
		iocContainer.setSchema({})
		expect(getFoo).toThrow('Element \'fooInstance\' not found in dependency schema')
	})

	it('returns the same element again for the same name', function() {
		iocContainer.setSchema({
			fooInstance: {ctor: function() {}}
		})

		var fooInstance = iocContainer.getElement('fooInstance')
		expect(iocContainer.getElement('fooInstance')).toBe(fooInstance)
	})

	it('sets element dependencies', function() {
		iocContainer.setSchema({
			fooInstance: {
				ctor: function(){},
				dependencies: {
					'_barProperty': 'barInstance'
				}
			},
			barInstance: {
				ctor: function(){}
			}
		})

		var fooInstance = iocContainer.getElement('fooInstance')
		expect(fooInstance._barProperty).toBe(iocContainer.getElement('barInstance'))
	})
})