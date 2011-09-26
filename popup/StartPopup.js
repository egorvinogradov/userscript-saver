$(function() {
	var popupOptionsWidget = new PopupOpenOptionsWidget()

	var jqueryButton = new JqueryButton()
	jqueryButton._jqueryFunction = $
	popupOptionsWidget._view = jqueryButton

	popupOptionsWidget.render($('body'))
})