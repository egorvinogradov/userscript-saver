class Controller extends Spine.Controller
	setModel: (model) ->
		assert model?, 'model should exist'
		assert @render? && @destroy?, 'should have methods \'render\' and \'destroy\''
		@item = model
		@item.bind "update",  @render
		@item.bind "destroy", @destroy

	render: =>
		assert @initialRender?, 'should have method @initialRender'
		if not @prerendered
			@initialRender()
			@prerendered = true

		if @refreshRender?
			@refreshRender()
