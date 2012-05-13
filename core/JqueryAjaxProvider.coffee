class JqueryAjaxProvider
	getUrlContent: (url, callback) ->
		$.ajax url,
			success: callback,
			error: (jqXHR, textStatus) -> console.log "JqueryAjaxProvider: error '#{textStatus}' while retrieving '#{url}'"
