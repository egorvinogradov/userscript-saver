class Controller extends Spine.Controller
	setModel: (model) ->
		@item = model
		@item.bind "update",  @render
		@item.bind "destroy", @destroy

