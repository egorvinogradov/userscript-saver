//workaround for developing taistie from IDE
//to use this file write needed code in corresponding local variables (write js code in js_func function body)

DevelopedTaistie = function() {
	var siteRegexp = 'your_tuned_site\\.com',
		css = '',
		jslib = [],
		jsFunction = function() {
			//place js code here

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
