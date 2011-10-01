//workaround for developing taistie from IDE
//to use this file:
// 1) set 'use' = true
// 2) write needed code in corresponding local variables in _getDevelopedTaistieData (write js code in js_func function body)
DevelopedTaistie = {
	use: true,

	developedTaistieData: (function() {
		//insert js code here
		var urlRegexp = 'lenta\\.ru', css = '', jsFunction = function() {
			var onePicLink = $('#gallery .onepic a'), currentImg = onePicLink.children('img'),
				thumbLinks = $('#gallery .micro a'), selectedClass = 'selected', selectedThumbSelector = '#gallery td' + '.' + selectedClass,
				descriptionBlockSelector = '#gallery td.onetext'

			$(document).keyup(function scrollByArrows(e) {
					//37 - left arrow, 39 - right arrow
					var targetLinkOffset = {37: 'prev', 39: 'next'}[e.which]
					if (targetLinkOffset !== undefined) loadNeighbourPicture(targetLinkOffset);
				}
			)

			currentImg.removeAttr('width').removeAttr('height')

			thumbLinks.click(function() {
				loadPictureByThumbLink(this)
				return false
			})
			onePicLink.click(function() {
				loadNeighbourPicture('next')
				return false
			})

			function loadNeighbourPicture(neighbourPosition) {
				var targetLinkOffset = {prev: -1, next: 1}[neighbourPosition]
				var picturePageLinks = $(thumbLinks)
				var currentLinkIndex = picturePageLinks.index($(selectedThumbSelector + ' a'))
				//loop elements: next element for the last one is the first one, and vise versa
				var picturePageLinkInThumb = picturePageLinks[(currentLinkIndex + targetLinkOffset +
					picturePageLinks.length) %
					picturePageLinks.length]
				loadPictureByThumbLink(picturePageLinkInThumb)
			}

			function loadPictureByThumbLink(picturePageLinkInThumb) {
				var imgOffset = currentImg.offset()
				var scrollTo = imgOffset.top - 10
				if ($('body').scrollTop() > scrollTo) { $('body').scrollTop(scrollTo)}

				//change text
				$(descriptionBlockSelector).load(picturePageLinkInThumb + ' ' + descriptionBlockSelector)

				var newPictureUrl = 'http://img.lenta.ru' +
					$(picturePageLinkInThumb).attr('href').replace('_Jpg.htm', '.jpg')
				//replace old picture with new one
				currentImg.attr('src', newPictureUrl)

				//change selected thumbnail
				$(selectedThumbSelector).removeClass(selectedClass)
				$(picturePageLinkInThumb).parent('td').addClass(selectedClass)
			}
		}

		var js = '(' + jsFunction.toString() + ')()'

		return {
			urlRegexp: urlRegexp,
			css: css,
			js: js
		}
	})()
}
