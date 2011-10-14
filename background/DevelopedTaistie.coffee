# workaround for developing taistie from IDE
# to use this file:
# 1) set 'use' = true
# 2) write needed code in corresponding local variables in _getDevelopedTaistieData (write js code in js_func function body)
DevelopedTaistie =
	use: true
	developedTaistieData: do ->
		urlRegexp = 'lenta\\.ru'
		css = ''
		jsFunction = ->
			#insert js code here
			onePicLink = $ '#gallery .onepic a'
			currentImg = onePicLink.children 'img'
			thumbLinks = $ '#gallery .micro a'
			selectedClass = 'selected'
			selectedThumbSelector = '#gallery td' + '.' + selectedClass
			descriptionBlockSelector = '#gallery td.onetext'

			$(document).keyup (e) ->
				#37 - left arrow, 39 - right arrow
				neighbourPositionsByArrowKeyCodes =
					37: 'prev'
					39: 'next'
				targetLinkOffset = neighbourPositionsByArrowKeyCodes[e.which]
				if targetLinkOffset isnt undefined
					loadNeighbourPicture targetLinkOffset

			currentImg.removeAttr 'width'
			currentImg.removeAttr 'height'

			thumbLinks.click ->
				loadPictureByThumbLink this
				return false

			onePicLink.click ->
				loadNeighbourPicture 'next'
				return false

			loadNeighbourPicture = (neighbourPosition) ->
				linkOffsetsByNeighbourPositions =
					prev: -1
					next: 1

				linkOffset = linkOffsetsByNeighbourPositions[neighbourPosition]
				picturePageLinks = $ thumbLinks
				currentLinkIndex = picturePageLinks.index $ selectedThumbSelector + ' a'

				#loop elements: next element for the last one is the first one, and vise versa
				loadedLinkIndex = currentLinkIndex + linkOffset + picturePageLinks.length
				loadedLink = picturePageLinks[loadedLinkIndex % picturePageLinks.length]

				loadPictureByThumbLink loadedLink

			loadPictureByThumbLink = (picturePageLinkInThumb) ->
				imgOffset = currentImg.offset()
				scrollTo = imgOffset.top - 10
				if $('body').scrollTop() > scrollTo
					$('body').scrollTop scrollTo

				#change text
				$(descriptionBlockSelector).load picturePageLinkInThumb + ' ' + descriptionBlockSelector

				newPictureUrl = 'http:#img.lenta.ru' + $(picturePageLinkInThumb).attr('href').replace '_Jpg.htm', '.jpg'
				#replace old picture with new one
				currentImg.attr 'src', newPictureUrl

				#change selected thumbnail
				$(selectedThumbSelector).removeClass selectedClass
				$(picturePageLinkInThumb).parent('td').addClass selectedClass

		js = '(' + jsFunction.toString() + ')()'

		return {
			urlRegexp: urlRegexp
			css: css
			js: js
		}
#		#TODO: вызвать сразу
