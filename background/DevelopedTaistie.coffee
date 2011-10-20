# workaround for developing taistie from IDE
# to use this file:
# 1) set 'use' = true
# 2) write needed code in corresponding local variables in _getDevelopedTaistieData (write js code in js_func function body)
DevelopedTaistie =
		urlRegexp: 'web-ready\\.ru'
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
				loadedBlockSelectors = ['.Mainmenu', '.Pagetext[style]']
				fancyBoxLoader = ->
					$.ajax
						url: $(this).attr('href')
						data: "mode=ajax"
						success: (html) ->
							$.fancybox(
								html
								'width' : 520
								'height': 520
								'autoDimensions': false)
					false

				initPager = (ancestorSelector) ->
					if ancestorSelector?
						$(ancestorSelector + ' .ajax_popup').click(fancyBoxLoader)

					ancestorSelector ?= ''
					for listPageLink in $(ancestorSelector + ' a[href^="\\?"]')
						$(listPageLink).attr('href', '/podannye_zayavki_2011/' + $(listPageLink).attr('href'))
					$(ancestorSelector + ' a[href^="/"]').add(ancestorSelector + ' a[href*="web-ready.ru/"]').not('.ajax_popup').click ->
						renewPageForLink @
						false

				renewPageForLink = (link) ->
					newUrl = $(link).attr('href')
					renewBlock(blockSelector, oldUrl, newUrl) for blockSelector in loadedBlockSelectors
					console.log(cachedBlocks)
					console.log(cachedBlocksInfo)
					oldUrl = newUrl

				renewBlock = (blockSelector, oldUrl, newUrl) ->
					jqBlock = $(blockSelector)
					offset = jqBlock.offset()
					scrollTo = offset.top - 10
					if $('body').scrollTop() > scrollTo
						$('body').scrollTop(scrollTo)
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
					key = blockSelector + ' : ' + url.replace('http://', '').replace('www.', '').replace('web-ready.ru/', '/')
					if key.substr(key.length - 4) == '?p=0'
						key = key.substr(0, key.length - 4)
					return key

				initPager(null)
