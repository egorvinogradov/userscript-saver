class JqueryAjaxProvider
	getUrlContent: (url, callback) ->
		$.ajax url, success: callback
