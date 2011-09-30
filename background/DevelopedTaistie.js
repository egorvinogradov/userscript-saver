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
					initPictureScroller()

					function initPictureScroller() {
						$(linkBlock).click(function() {
							loadNewPicturePage($(this).attr('href'))
							return false
						})
					}

					function loadNewPicturePage(newPicturePageLink) {
                        //make history universal
						window.history.pushState({}, "next Page", newPicturePageLink)

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
