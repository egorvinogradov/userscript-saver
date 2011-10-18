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
	popupOptionsWidget._element = $('<input type = "checkbox" id="taistieEnabled">')
	popupOptionsWidget._element.css({
		'text-align': 'left'
	})
	$('.popupWidget').append(popupOptionsWidget._element)
	$('.popupWidget').append($('<label for="taistieEnabled">Ускоритель: быстрая повторная загрузка</label>'))
	popupOptionsWidget.prerender()
})
