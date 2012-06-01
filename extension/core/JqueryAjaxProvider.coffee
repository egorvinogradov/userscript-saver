class JqueryAjaxProvider
	getUrlContent: (url, callback) ->
		$.ajax url,
			success: callback
			contentType: 'text/plain'
			error: (jqXHR, textStatus, errorThrown) -> console.log "JqueryAjaxProvider: error '#{textStatus}: #{errorThrown}' while retrieving '#{url}'"
