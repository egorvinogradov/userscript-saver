//workaround for developing taistie from IDE
//to use this file:
// 1) set 'use' = true
// 2) write needed code in corresponding local variables in _getDevelopedTaistieData (write js code in js_func function body)
DevelopedTaistie = {
	use: true,

	developedTaistieData: (function() {
		//insert js code here
		var siteRegexp = 'lenta\\.ru',
				css = '',
				jsFunction = function() {
					var contentBlock = '#gallery', linkBlock = '#gallery a'
					initScroller()

					function initScroller() {
						$(linkBlock).click(function() {
							loadNewPicturePage($(this).attr('href'))
							return false
						})
					}

					function loadNewPicturePage(newPicturePageLink) {
						window.history.pushState({}, "next Page", $(this).attr('href'))
						var jqContentBlock = $(contentBlock)
						var contentBlockOffset = jqContentBlock.offset()

						var contentBlockTop = contentBlockOffset.top
						var contentBlockLeft = contentBlockOffset.left
						var contentBlockHeight = jqContentBlock.height()
						var contentBlockWidth = jqContentBlock.width()

						$('body').scrollTop(contentBlockTop)
						jqContentBlock.prepend('<div style="' + 'position: absolute; top: ' + contentBlockTop
								                       + 'px; left: ' + contentBlockLeft + 'px; width: '
								                       + contentBlockWidth + 'px; height: ' + contentBlockHeight
								                       + 'px; display: block; background-color: black; -moz-opacity: 0.5; opacity:.5;  filter: alpha(opacity=50);">'
								                       + '</div>')
						$(contentBlock).load(newPicturePageLink + ' ' + contentBlock + ' > *', initScroller)
					}
				}

		var js = '(' + jsFunction.toString() + ')()'

		return {
			siteRegexp: siteRegexp,
			css: css,
			js: js
		}
	})()
}
