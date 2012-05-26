class Dislike
	constructor: ->
		@_dislikes = []

	add: (dislike) ->
		@_dislikes.push dislike

	count: -> @_dislikes.length

	getAllDislikes: ->
		return (dislike for dislike in @_dislikes)
