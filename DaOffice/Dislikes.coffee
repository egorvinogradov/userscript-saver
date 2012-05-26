class Dislikes
	constructor: ->
		@_dislikes = []

	count: -> @_dislikes.length

	add: (dislike) ->
		@_dislikes.push dislike

	remove: (removed) ->
		removedIndex = undefined
		removedIndex = i for dislike, i in @_dislikes when dislike.ideaId is removed.ideaId and dislike.userId is removed.userId
		assert(removedIndex?, "remove: Dislike #{ JSON.stringify(removed) } does not exist")
		@_dislikes.splice(removedIndex, 1)

	save: ->
		@_database.save @_dislikes

	restore: -> @_database.restore()

	getAllDislikes: ->
		return (dislike for dislike in @_dislikes)
