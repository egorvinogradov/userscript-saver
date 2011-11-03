class SingleValueController
	constructor: (domElement)->
		@_domElement = domElement

	init: (options) ->
		#TODO: проверять, что если модель задана, она имеет весь необходимый интерфейс
		#TODO: РїСЂРѕРІРµСЂСЏС‚СЊ, С‡С‚Рѕ options Р·Р°РґР°РЅС‹, РЅРѕ РєРѕСЂСЂРµРєС‚РЅРѕ СЂР°Р±РѕС‚Р°РµС‚ Рё СЃ РїСѓСЃС‚С‹РјРё

		for eventName, eventHandler of options.events
			#TODO: РІС‹РЅРµСЃС‚Рё РІ РїСЂРѕРІРµСЂРєСѓ РґР°РЅРЅС‹С… РїСЂРё РёС… РїРµСЂРІРѕРј РїРѕР»СѓС‡РµРЅРёРё РІ Controller
			assert typeof eventHandler == 'function', "invalid handler type: #{typeof eventHandler} for event #{eventName}"
			do(eventName, eventHandler) =>
				@_domElement.subscribeToEvent eventName, eventHandler

		model = options.model
		attribute = options.modelAttribute

		#TODO: РїСЂРѕРІРµСЂСЏС‚СЊ, С‡С‚Рѕ Р·Р°РґР°РЅС‹/РЅРµ Р·Р°РґР°РЅС‹ РѕРґРЅРѕРІСЂРµРјРµРЅРЅРѕ РјРѕРґРµР»СЊ Рё РёРјСЏ Р°С‚СЂРёР±СѓС‚Р°
#		console.log attribute, model
		if attribute?
			@_domElement.setValueChangeListener (newValue) ->
				model.updateAttribute attribute, newValue

			model.bind 'update', => @_domElement.setValue model.attributes()[attribute]
