describe 'Dislike', ->
	it 'has zero count when has no dislikes', ->
		dislike = new Dislike()
		expect(dislike.count()).toEqual(0)

	it 'increases dislikes count when new dislike is added', ->
		dislike = new Dislike()
		dislike.add
			userId: 1
			ideaId: 1

		expect(dislike.count()).toEqual 1

	it 'returns all dislikes on getAllDislikes()', ->
		dislike = new Dislike()
		dislike.add
			userId: 1
			ideaId: 1

		expect(dislike.getAllDislikes()).toEqual [
			userId: 1
			ideaId: 1
		]
