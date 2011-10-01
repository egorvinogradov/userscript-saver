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
					//37 - left arrow, 39 - right arrow
					var targetLinkOffset = {37: 'prev', 39: 'next'}[e.which]
					if (targetLinkOffset !== undefined) loadNeighbourPicture(targetLinkOffset);
				}
			)
			initPictureScroller()

			function initPictureScroller() {
				$(thumbLinks).click(function() {
					loadPictureByThumbLink(this)
					return false
				})
				$(onePicLink).click(function(){
					loadNeighbourPicture('next')
					return false
				})
			}

			function loadNeighbourPicture(neighbourPosition) {
				var targetLinkOffset = {prev: -1, next: 1}[neighbourPosition]
				var picturePageLinks = $(thumbLinks)
				var currentLinkIndex = picturePageLinks.index($('#gallery td.selected a'))
				//loop elements: next element for the last one is the first one, and vise versa
				var picturePageLinkInThumb = picturePageLinks[(currentLinkIndex + targetLinkOffset +
					picturePageLinks.length) %
					picturePageLinks.length]
				loadPictureByThumbLink(picturePageLinkInThumb)
			}

			function loadPictureByThumbLink(picturePageLinkInThumb) {
				var picBlockOffset = $(picBlock).offset()
				var scrollTo = picBlockOffset.top - 10
				if ($('body').scrollTop() > scrollTo) { $('body').scrollTop(scrollTo)}

				//replace old picture with new one
				$(contentBlock).load(picturePageLinkInThumb + ' ' + contentBlock + ' > *', initPictureScroller)
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
