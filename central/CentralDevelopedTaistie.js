//workaround for developing taistie from IDE
//to use this file write needed code in corresponding local variables (write js code in js_func function body)

DevelopedTaistie = function() {
	var siteRegexp = 'habrahabr\\.ru',
		css = '',
		jslib = ['lib/jquery.js'],
		jsFunction = function() {
			//place js code here
			(function initScroller() {
				$('.page-nav a').click(function() {
					$('#main-content').load($(this).attr('href') + ' #main-content > *',
						function(){initScroller()})
					return false
				})
			})()
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
