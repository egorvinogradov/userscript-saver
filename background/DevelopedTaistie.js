//workaround for developing taistie from IDE
//to use this file:
// 1) set 'use' = true
// 2) write needed code in corresponding local variables in _getDevelopedTaistieData (write js code in js_func function body)
DevelopedTaistie = {
	use: true,

	developedTaistieData: (function() {
		//insert js code here
		var urlRegexp = 'lenta\\.ru', css = '', jsFunction = function() {
			var contentBlock = '#gallery', onePicLink = '#gallery .onepic a', thumbLinks = ' #gallery .micro a', picBlock = '#gallery .onepic img'

			$(document).keyup(function scrollByArrows(e) {
					//37 - код стрелки влево, 39 - вправо
					var targetLinkOffset = {37: -1, 39: 1}[e.which]
					if (targetLinkOffset !== undefined) {
						var picturePageLinks = $(thumbLinks)
						var currentLinkIndex = picturePageLinks.index($('#gallery td.selected a'))
						//loop elements: next element for the last one is the first one, and vise versa
						var newPicturePageLink = picturePageLinks[(currentLinkIndex + targetLinkOffset +
							picturePageLinks.length) %
							picturePageLinks.length]
						loadNewPicturePage(newPicturePageLink)
					}
				}
			)

			initPictureScroller()

			function initPictureScroller() {
				$(onePicLink + ', ' + thumbLinks).click(function() {
					loadNewPicturePage($(this).attr('href'))
					return false
				})
			}

			function loadNewPicturePage(newPicturePageLink) {
				var picBlockOffset = $(picBlock).offset()
				var scrollTo = picBlockOffset.top - 10
				if ($('body').scrollTop() > scrollTo) { $('body').scrollTop(scrollTo)}

				//поставляем новое содержимое галереи - из новой страницы
				$(contentBlock).load(newPicturePageLink + ' ' + contentBlock + ' > *', initPictureScroller)
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
