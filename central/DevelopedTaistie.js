//workaround for developing taistie from IDE
//to use this file:
// 1) set 'use' = true
// 2) write needed code in corresponding local variables in _getDevelopedTaistieData (write js code in js_func function body)
DevelopedTaistie = {
	use: true,

	developedTaistieData: (function() {
		//insert js code here
		var urlRegexp = 'lenta\\.ru',
				css = '',
				jsFunction = function() {
					var contentBlock = '#gallery', linkBlock = '#gallery a', picBlock = '.onepic img'
					initScroller()

					function initScroller() {
						$(linkBlock).click(function() {
							loadNewPicturePage($(this).attr('href'))
							return false
						})
					}

					function loadNewPicturePage(newPicturePageLink) {
						window.history.pushState({}, "next Page", $(this).attr('href'))
						var jqPicBlock = $(picBlock)
						var picBlockOffset = $(jqPicBlock).offset()
						var scrollTo = picBlockOffset.top - 10

						if ($('body').scrollTop() > scrollTo) { $('body').scrollTop(scrollTo)}
						$(contentBlock).load(newPicturePageLink + ' ' + contentBlock + ' > *', initScroller)
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
