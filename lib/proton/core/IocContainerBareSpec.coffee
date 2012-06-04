describe 'IocContainer', ->
	iocContainer = null
	beforeEach ->
		iocContainer = new IocContainerBare

	describe 'schema instance contents meaning:', ->
		describe 'single', ->
			it 'returns the only instance of given class', ->
				class Foo
					constructor: -> @name = 'Foo'
				iocContainer.setSchema
					fooInstance:
						single: Foo

				foo1 = iocContainer.getInstance 'fooInstance'
				expect(foo1.name).toEqual 'Foo'

				foo2 = iocContainer.getInstance 'fooInstance'
				expect(foo2).toBe foo1

		describe 'ref', ->
			it 'gets existing object by direct reference', ->
				foo = {}
				iocContainer.setSchema
					fooInstance:
						ref: foo

				expect(iocContainer.getInstance 'fooInstance').toBe foo

		describe 'factoryFunction', ->
			#TODO: спеки на работу с dependencies - должны проставляться самим экземплярам
			it 'returns function to create new objects accepting any parameters', ->
				class Foo
					constructor: (@name) ->

				iocContainer.setSchema
					fooFactory:
						factoryFunction: Foo

				fooFactory = iocContainer.getInstance 'fooFactory'
				foo1 = fooFactory 'foo1'
				foo2 = fooFactory 'foo2'

				expect(foo2).not.toBe foo1
				expect(foo1.name).toEqual 'foo1'
				expect(foo2.name).toEqual 'foo2'

		describe 'deps', ->
			it 'sets instance dependencies with other schema instances using their names in schema', ->
				iocContainer.setSchema
					fooInstance:
						single: ->
						deps:
							'_barProperty': 'barInstance'
					barInstance:
						single: ->

				fooInstance = iocContainer.getInstance 'fooInstance'
				expect(fooInstance._barProperty).toBe iocContainer.getInstance('barInstance')

	describe 'setSchema: sets dependency schema to use', ->
		#TODO: добавить позитивные спеки

	describe 'getInstance: gets instance by its name in schema', ->
		#TODO: добавить позитивные спеки

