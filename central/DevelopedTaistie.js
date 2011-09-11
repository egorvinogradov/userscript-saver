//workaround for developing taistie from IDE
//to use this file:
// 1) set 'use' = true
// 2) write needed code in corresponding local variables in _getDevelopedTaistieData (write js code in js_func function body)
DevelopedTaistie = {
	use: true,

	developedTaistieData: (function() {
		var siteRegexp = 'lenta\\.ru',
				css = '',
				jslib = ['lib/jquery.js'],
				jsFunction = function() {
					//place js code here

					function initScroller(contentBlock, linkBlock) {
						$(linkBlock).click(function() {

							//TODO: isn't supported in IE - need workaround like history.js
							window.history.pushState({}, "next Page", $(this).attr('href'))
							var jqContentBlock = $(contentBlock);
							var contentBlockOffset = jqContentBlock.offset();

							var contentBlockTop = contentBlockOffset.top
							var contentBlockLeft = contentBlockOffset.left;
							var contentBlockHeight = jqContentBlock.height();
							var contentBlockWidth = jqContentBlock.width();

							$('body').scrollTop(contentBlockTop)
							jqContentBlock.prepend('<div style="' + 'position: absolute; top: ' + contentBlockTop
									                       + 'px; left: ' + contentBlockLeft + 'px; width: '
									                       + contentBlockWidth + 'px; height: ' + contentBlockHeight
									                       + 'px; display: block; background-color: black; -moz-opacity: 0.5; opacity:.5;  filter: alpha(opacity=50);">'
									                       + '</div>')
							$(contentBlock).load($(this).attr('href') + ' ' + contentBlock + ' > *', function() {
								initAllScrollers()
							})
							return false
						})
					}

					function initAllScrollers() {
						var scrolledBlockDescriptions = [
							{
								contentBlock: '#gallery',
								linkBlock: '#gallery a'
							}
							//                    'habrahabr\\.ru'
							//                    {
							//                        contentBlock: '#main-content',
							//                        linkBlock: '.page-nav a'
							//                    }
						]

						$.each(scrolledBlockDescriptions, function(index, scrolledBlockDescription) {
							initScroller(scrolledBlockDescription.contentBlock, scrolledBlockDescription.linkBlock)
						})
					}

					initAllScrollers();
				}

		var js = '(' + jsFunction.toString() + ')()'

		return {
			siteRegexp: siteRegexp,
			contents: {
				css: css,
				jslib: jslib,
				js: js
			}
		}
	})()
}
