$(function() {
	var popupOptionsWidget = new PopupOpenOptionsWidget()

	popupOptionsWidget._view = new JqueryButton()
	popupOptionsWidget._jqueryFunction = $
	popupOptionsWidget.render({createChildElement: function(tagName){return $('body').}})
})