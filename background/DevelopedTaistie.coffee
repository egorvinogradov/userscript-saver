# workaround for developing taistie from IDE
# to use this file:
# 1) set 'use' = true
# 2) write needed code in corresponding local variables in _getDevelopedTaistieData (write js code in js_func function body)
DevelopedTaistie =
		urlRegexp: 'www\\.techstars\\.com'
		css: ''
		name: 'Accelerator: instant repeated page loading'
		active: on
		js: do ->
			functionToClosureText = (jsFunction) ->	'(' + jsFunction.toString() + ')()'
			functionToClosureText ->
				cachedBlocksInfo = {}
				cachedBlocks = $('<div class="cached_blocks" style="display: none;"></>')
				$('body').append(cachedBlocks)

				oldUrl = window.location.href
				loadedBlockSelectors = ['#menu-primary-navigation', '#main']

				initPager = (ancestorSelector = '') ->
					watchedLinks = $(ancestorSelector + ' a[href^="/"]').add(ancestorSelector + ' a[href*="www.techstars.com/"]')
					watchedLinks.click ->
						renewPageForLink $(@).attr('href')
						false

				renewPageForLink = (newUrl) ->
					if oldUrl != newUrl
						renewBlock(blockSelector, oldUrl, newUrl) for blockSelector in loadedBlockSelectors
						oldUrl = newUrl

				renewBlock = (blockSelector, oldUrl, newUrl) ->
					jqBlock = $(blockSelector)
					$('body').scrollTop 0
					storeInCache blockSelector, oldUrl

					renewed = renewFromCache blockSelector, newUrl
					if not renewed
						jqBlock.append('<img src="http://www.mobileciti.com.au/skin/frontend/default/mobileciti_v2/images/ajax-loader.gif" />')
						jqBlock.load newUrl + ' '+ blockSelector + ' > *', ->
							initPager blockSelector

				renewFromCache = (blockSelector, loadedLink) ->
					blockKey = getBlockKey blockSelector, loadedLink
					cachedBlockInfo = cachedBlocksInfo[blockKey]
					if not cachedBlockInfo?
						return false
					newBlock = $(cachedBlocks.children()[cachedBlockInfo.blockIndex])

					if newBlock.children().length = 0
						return false

					$(blockSelector).append(newBlock.children())
					return true

				storeInCache = (blockSelector, url) ->
					blockKey = getBlockKey blockSelector, url
					cachedBlockInfo = cachedBlocksInfo[blockKey]
					cachedBlock = null
					if not cachedBlockInfo?
						cachedBlock = $('<div></div>')
						cachedBlock.appendTo(cachedBlocks)
						cachedBlocksInfo[blockKey] =
							blockIndex: cachedBlocks.children().length - 1
					else
						cachedBlock = $(cachedBlocks.children()[cachedBlockInfo.blockIndex])
					cachedBlock.append($(blockSelector + ' > *'))

				getBlockKey = (blockSelector, url) ->
					key = blockSelector + ' : ' + url.replace('http://', '').replace('www.', '').replace('techstars.com/', '/')
					if key.substr(key.length - 4) == '?p=0'
						key = key.substr(0, key.length - 4)
					return key

				initPager()
