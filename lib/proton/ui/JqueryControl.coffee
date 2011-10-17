class JqueryControl
	setJqueryElement: (jqueryElement) ->
		@_jqueryElement = jqueryElement
	getValue: ->
		if @_jqueryElement.attr('type') is 'checkbox'
			@_jqueryElement.is(':checked')
		else
			@_jqueryElement.val()
