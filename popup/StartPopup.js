$(function() {

	var iocContainer = new IocContainer()
	iocContainer.setSchema({
		topPopupWidget: {
			ctor: PopupOpenOptionsWidget,
			deps: {_jqueryFunction: 'jquery', _tabApi: TabApi}
		},
		jquery: {
			ref: $
		}
	})

	var popupOptionsWidget = iocContainer.getElement('topPopupWidget')
	popupOptionsWidget.render($('body'))
})