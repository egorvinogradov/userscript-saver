class Taistie extends Spine.Model
	@_userscriptsDownloader = null

	@configure "Taistie", "name", "active", "rootUrl", "css", "js", "source", "externalId", "description", "usageCount"

	constructor: (options) ->
		msgPrefix = 'Taistie creation: '
		assert options?, "#{msgPrefix}field values data required (in dictionary)"
		options.source ?= 'own'
		assert ['own', 'userscripts'].indexOf(options.source) >= 0, "#{msgPrefix}invalid \'source\' value \'#{options.source}\'"
		super options

	@extend Spine.Model.Local

	fitsUrl: (url) ->
		return url.indexOf(@rootUrl) >= 0

	getCss: ->
		@css ? ''

	getJs: ->
		if (@js ? '') is '' then '' else '(function(){' + @js + '})();'

	getName: ->
		@name

	isActive: ->
		@active

	isOwnTaistie: -> @source == 'own'

	isUserscript: -> @source == 'userscripts'

	getDescription: -> @description

	getExternalId: -> @externalId

	getExternalLink: ->
		if @isOwnTaistie() then null else "http://userscripts.org/scripts/show/#{@getExternalId()}"

	@getTaistiesForUrl: (url) ->
		assert url? and url != '', 'url should be given'
		existingTaisties = @select (taistie) -> taistie.fitsUrl url

		existingTaisties.concat @_getUserscriptsForUrl url, existingTaisties

	@_getUserscriptsForUrl: (url, existingTaisties) ->
		userscripts = @_userscriptsDownloader.getUserscriptsForUrl url
		taistiesFromUserScripts = []
		for userscript in userscripts
			do (userscript) ->
				taistieExists = false
				taistieExists = true for taistie in existingTaisties when taistie.source is 'userscripts' and taistie.externalId is userscript.id

				if not taistieExists
					taistieFromUserscript = Taistie.create
						name: userscript.name
						js: userscript.js
						description: userscript.description

						#TODO: проставлять url здесь, в Taistie
						rootUrl: userscript.rootUrl
						source: 'userscripts'
						externalId: userscript.id
					taistiesFromUserScripts.push taistieFromUserscript
		taistiesFromUserScripts


