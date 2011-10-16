class Controller extends Spine.Controller
	setModel: (model) ->
		assert model?, 'model should exist'
		assert @render? && @destroy?, 'should have methods \'render\' and \'destroy\''
		@item = model
		@item.bind "update",  @render
		@item.bind "destroy", @destroy
