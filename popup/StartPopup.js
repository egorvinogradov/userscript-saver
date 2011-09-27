$(function() {

	var iocContainer = new IocContainer()
	iocContainer.setSchema({
		topPopupWidget: {
			ctor: PopupOpenOptionsWidget,
			deps: {_view: 'jqueryButton'}
		},
		jqueryButton: {
			ctor: JqueryButton,
			deps: {_jqueryFunction: 'jquery'}
		},
		jquery: {
			ref: $
		}
	})

	var popupOptionsWidget = iocContainer.getElement('topPopupWidget')
	popupOptionsWidget.render($('body'))
})