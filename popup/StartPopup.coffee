$ ->
	iocContainer = new IocContainer()
	iocContainer.setSchema
		topPopupWidget:
			single: PopupOpenOptionsWidget
			deps: _tabApi: 'tabApi'
		tabApi:
			ref: TabApi

	popupOptionsWidget = iocContainer.getElement 'topPopupWidget'
	popupOptionsWidget._element = $ '<input type = "checkbox" id="taistieEnabled">'
	popupOptionsWidget._element.css
		'text-align': 'left'

	$('.popupWidget').append popupOptionsWidget._element
	$('.popupWidget').append $('<label for="taistieEnabled">Accelerator: instant page loading</label>')
	popupOptionsWidget.prerender()

