class Taistie extends Spine.Model
	@_taistiesDownloader = null

	@configure "Taistie", "name", "active", "rootUrl", "css", "js", "source", "externalId", "description", "usageCount"

	constructor: (options) ->
		msgPrefix = 'Taistie creation: '
		assert options?, "#{msgPrefix}field values data required (in dictionary)"
		options.source ?= 'own'
		assert ['own', 'remote'].indexOf(options.source) >= 0, "#{msgPrefix}invalid \'source\' value \'#{options.source}\'"
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

	isOwn: -> @source == 'own'

	isRemote: -> @source == 'remote'

	getDescription: -> @description

	getExternalId: -> @externalId

	getExternalLink: ->	if @isRemote() then "http://taisties.org/scripts/show/#{@getExternalId()}" else null

	getUsageCount: -> @usageCount

	getRootUrl: -> @rootUrl

	@getTaistiesForUrl: (url, callback) ->
		assert url? and url != '', 'url should be given'
		localTaisties = @getLocalTaistiesForUrl(url)

		localTaistieExists = false
		localTaistieExists = true for taistie in localTaisties when taistie.isRemote()

		if localTaistieExists
			callback localTaisties
		else
			@_getRemoteTaistiesForUrl url, localTaisties, (taisties) -> callback(localTaisties.concat taisties)

	@getActiveTaistiesForUrl: (url) ->
		taistie for taistie in @getLocalTaistiesForUrl(url) when taistie.isActive()

	@getLocalTaistiesForUrl: (url) ->
		@select (taistie) -> taistie.fitsUrl url

	@_getRemoteTaistiesForUrl: (url, existingTaisties, callback) ->
		@_taistiesDownloader.getTaistiesForUrl url, (taisties) ->
			localTaistiesFromRemote = []
			for remoteTaistie in taisties
				do (remoteTaistie) ->
					taistieExists = false
					taistieExists = true for taistie in existingTaisties when taistie.isRemote() and taistie.externalId is remoteTaistie.id

					if not taistieExists
						localTaistieFromRemote = Taistie.create
							name: remoteTaistie.name
							js: remoteTaistie.js
							description: remoteTaistie.description

							#TODO: проставлять url здесь, в Taistie
							rootUrl: remoteTaistie.rootUrl
							source: 'remote'
							externalId: remoteTaistie.id
							usageCount: remoteTaistie.usageCount
						localTaistiesFromRemote.push localTaistieFromRemote
			callback localTaistiesFromRemote

	@getAllOwnTaisties: -> @select (taistie) -> taistie.isOwn()

