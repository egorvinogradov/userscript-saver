class JqueryAjaxProvider
	getUrlContent: (url, callback) ->

		#temporary workaround: don't get userscripts content because browsers instantly loads and executes it as userscript
		#TODO: remove workaround for userscripts - replace with our server calls
		if url.indexOf('user.js') > 0
			callback("console.log('userscript loaded: #{url}');" + "alert('userscript loaded: #{url}')")
		else
		$.ajax url,
			success: callback,
			error: (jqXHR, textStatus) -> console.log "JqueryAjaxProvider: error '#{textStatus}' while retrieving '#{url}'"
