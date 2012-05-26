describe 'Dislikes', ->

	dislike1 =
		userId: 1
		ideaId: 1

	dislikes = undefined

	beforeEach ->
		dislikes = new Dislikes()

	it 'has zero count when has no dislikes', ->
		expect(dislikes.count()).toEqual(0)

	it 'increases dislikes count when new dislike is added', ->
		dislikes.add dislike1
		expect(dislikes.count()).toEqual 1

	it 'returns all dislikes on getAllDislikes()', ->
		dislikes.add dislike1
		expect(dislikes.getAllDislikes()).toEqual [dislike1]

	it 'decreases dislikes count when existing dislike is removed', ->
		dislikes.add dislike1
		dislikes.remove dislike1
		expect(dislikes.count()).toEqual 0

	it 'throws when unexisting dislike is removed', ->
		expect(->
			dislikes.remove dislike1
		).toThrow("remove: Dislike #{ JSON.stringify(dislike1) } does not exist")

	it 'saves dislikes on save() and restores on restore()', ->

		mockDatabase =
			save: (dbContent) ->
				@_dbContent = dbContent
			restore: -> @_dbContent

		dislikes._database = mockDatabase
			
		dislikes.add(dislike1)
		dislikes.save()
		dislikes2 = new Dislikes()

		dislikes2._database = mockDatabase

		dislikes2.restore()
		expect(dislikes2.getAllDislikes()).toEqual[dislike1]

