class Controller extends Spine.Controller
	setModel: (model) ->
		assert model?, 'model should exist'
		assert @render? && @destroy?, 'should have methods \'render\' and \'destroy\''
		@item = model
		@item.bind "update",  @render
		@item.bind "destroy", @destroy

	render: =>
		if not @prerendered
			@initialRender()
			@prerendered = true

		if @refreshRender?
			@refreshRender()

	initialRender: ->
		@el = $(".#{@selector}.template").clone().removeClass('template')
		@delegateEvents()
		@refreshElements()

		for selector, propertyName of @newElements
			do (selector, propertyName) =>
				jqueryControl = new JqueryControl
				jqueryControl.setJqueryElement @$(selector)
				jqueryControl.setValueChangeListener (jqueryControl, newValue) =>
					@item.updateAttribute propertyName, newValue

