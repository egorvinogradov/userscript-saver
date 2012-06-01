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

	getJsForInsertion: ->
		if (@js ? '') is '' then '' else '(function(){' + @js + '})();'

	getRawJs: -> @js

	getName: ->	@name

	isActive: -> @active

	isOwnTaistie: -> @source == 'own'

	isUserscript: -> @source == 'userscripts'

	getDescription: -> @description

	getExternalId: -> @externalId

	getExternalLink: ->	if @isUserscript() then "http://userscripts.org/scripts/show/#{@getExternalId()}" else null

	getUsageCount: -> @usageCount

	getRootUrl: -> @rootUrl

	@getTaistiesForUrl: (url, callback) ->
		assert url? and url != '', 'url should be given'
		localTaisties = @getLocalTaistiesForUrl(url)

		localUserscriptExists = false
		localUserscriptExists = true for taistie in localTaisties when taistie.isUserscript()

		if localUserscriptExists
			callback localTaisties
		else
			@_getUserscriptsForUrl url, localTaisties, (userscripts) -> callback(localTaisties.concat userscripts)

	@getActiveTaistiesForUrl: (url) ->
		taistie for taistie in @getLocalTaistiesForUrl(url) when taistie.isActive()

	@getLocalTaistiesForUrl: (url) ->
		@select (taistie) -> taistie.fitsUrl url

	@_getUserscriptsForUrl: (url, existingTaisties, callback) ->
		@_userscriptsDownloader.getUserscriptsForUrl url, (userscripts) ->
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
							usageCount: userscript.usageCount
						taistiesFromUserScripts.push taistieFromUserscript
			callback taistiesFromUserScripts

	@getAllOwnTaisties: -> @select (taistie) -> taistie.isOwnTaistie()

