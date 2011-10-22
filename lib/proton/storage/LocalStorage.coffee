class LocalStorage
	constructor:
		@_localStorage = window.localStorage

	#TODO: specs, IoC, etc
	put: (key, value) ->
		@_localStorage.setItem key, JSON.stringify(value)

	
	get: (key) ->
		return JSON.parse @_localStorage.getItem(key)
