//workaround for developing taistie from IDE
//to use this file write needed code in corresponding local variables (write js code in js_func function body)

DevelopedTaistie = function() {
	var siteRegexp = 'habrahabr\\.ru',
		css = '',
		jslib = ['lib/jquery.js'],
		jsFunction = function() {
			//place js code here

			function initScroller(contentBlock, linkBlock) {
				$(linkBlock).click(function() {
					$(contentBlock).load($(this).attr('href') + ' ' + contentBlock + ' > *', function() {
						initAllScrollers()})
					return false
				})
			}

			function initAllScrollers() {
                var scrolledBlockDescriptions = [
                    {
                        contentBlock: '#main-content',
                        linkBlock: '.page-nav a'
                    }
                ]

				$.each(scrolledBlockDescriptions, function(index, scrolledBlockDescription) {
					initScroller(scrolledBlockDescription.contentBlock, scrolledBlockDescription.linkBlock)
				})
			}

            initAllScrollers();
		}

	var js = '(' + jsFunction.toString() + ')()';

	return {
		siteRegexp: siteRegexp,
		contents: {
			css: css,
			jslib: jslib,
			js: js
		}
	}
}
