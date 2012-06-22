class Taistie extends Spine.Model
	@_taistiesDownloader = null

	@configure "Taistie", "name", "active", "rootUrl", "css", "js", "externalId", "description", "usageCount"

	constructor: (options) ->
		msgPrefix = 'Taistie creation: '
		assert options?, "#{msgPrefix}field values data required (in dictionary)"
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

	getDescription: -> @description

	getExternalLink: ->	"http://tai.st/server/taisties/show/#{@getExternalId()}"

	getExternalId: -> @externalId

	getUsageCount: -> @usageCount

	getRootUrl: -> @rootUrl

	@getTaistiesForUrl: (url, callback) ->
		assert url? and url != '', 'url should be given'
		localTaisties = @getCachedTaistiesForUrl(url)

		@_taistiesDownloader.getTaistiesForUrl url, (remoteTaisties) ->
			for remoteTaistie in remoteTaisties
				do (remoteTaistie) ->
					localTaistie = taistie for taistie in localTaisties when taistie.externalId is remoteTaistie.id
					if not localTaistie
						localTaistie = Taistie.create
							active: false
							#TODO: проставлять url здесь, в Taistie
							rootUrl: remoteTaistie.rootUrl
							externalId: remoteTaistie.id
						localTaisties.push localTaistie

					localTaistie.updateAttributes
						name: remoteTaistie.name
						js: remoteTaistie.js
						description: remoteTaistie.description
						css: remoteTaistie.css
						usageCount: remoteTaistie.usageCount

			callback localTaisties

	@getActiveTaistiesForUrl: (url) ->
		taistie for taistie in @getCachedTaistiesForUrl(url) when taistie.isActive()

	@getCachedTaistiesForUrl: (url) ->
		@select (taistie) -> taistie.fitsUrl url

	#TODO: убрать работу с собственными taistie (позднее сделать ее через проверку авторства)
	@getAllOwnTaisties: -> []

