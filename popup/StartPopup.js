$(function() {

	var iocContainer = new IocContainer()
	iocContainer.setSchema({
		topPopupWidget: {
			ctor: PopupOpenOptionsWidget,
			dependencies: {_view: 'jqueryButton'}
		},
		jqueryButton: {
			ctor: JqueryButton,
			dependencies: {_jqueryFunction: 'jquery'}
		},
		jquery: {
			reference: $
		}
	})

	var popupOptionsWidget = iocContainer.getElement('topPopupWidget')
	popupOptionsWidget.render($('body'))
})