$(function() {

	var iocContainer = new IocContainer()
	iocContainer.setSchema({
		topPopupWidget: {
			ctor: PopupOpenOptionsWidget,
			deps: {_tabApi: 'tabApi'}
		},
		tabApi: {
			ref: TabApi
		}
	})

	var popupOptionsWidget = iocContainer.getElement('topPopupWidget')
	popupOptionsWidget._element = $('<' + popupOptionsWidget._tagName + '/>')
	$('body').append(popupOptionsWidget._element)
	popupOptionsWidget.prerender()
})