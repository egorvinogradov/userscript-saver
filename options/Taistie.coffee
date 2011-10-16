class Taistie extends Spine.Model
	@configure "Taistie", "name", "active", "urlRegexp", "css", "js"

	@extend Spine.Model.Local

	@active: -> @select (item) -> item.active

	@inactive: -> @select (item) -> !item.active

	@destroyDone: -> rec.destroy() for rec in @inactive()