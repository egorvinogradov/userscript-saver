describe 'PlainDomControl', ->
	plainDomInput = null
	plainDomCheckbox = null
	plainDomSpan = null
	control = null

	beforeEach ->
		plainDomCheckbox = $ '<input type="checkbox"/>'
		plainDomInput = $ '<input type="text"/>'
		plainDomSpan = $ '<span></span>'
		control = new PlainDomControl

	it 'setDomAccessor: accepts jquery-like object', ->
		expectedEx = new AssertException 'domAccessor should be valid jquery-like object'
		expect(-> control.setDomAccessor invalidAccessor).toThrow expectedEx for invalidAccessor in [null, {}]
		control.setDomAccessor plainDomInput
		expect(control.getDomAccessor()).toBe plainDomInput

	it 'getDomAccessor: returns dom accessor', ->

	describe 'getValue', ->
		it 'returns true/false for checked/unchecked checkbox', ->
			control.setDomAccessor plainDomCheckbox

			expect(control.getValue()).toEqual off

			plainDomCheckbox.attr 'checked', on
			expect(control.getValue()).toEqual on

			plainDomCheckbox.attr 'checked', off
			expect(control.getValue()).toEqual off

		it 'returns jquery.val() for any input except checkbox', ->
			control.setDomAccessor plainDomInput
			expect(control.getValue()).toEqual ''

			plainDomInput.val 'foo'
			expect(control.getValue()).toEqual 'foo'

		it 'returns inner html for any non-input element', ->
			control.setDomAccessor plainDomSpan
			expect(control.getValue()).toEqual ''

			plainDomSpan.html '<b>inner html</b>'
			expect(control.getValue()).toEqual '<b>inner html</b>'

	describe 'setValue', ->
		it 'allows to set text value to input except checkbox', ->
			control.setDomAccessor plainDomInput
			control.setValue 'newValue'
			expect(control.getValue()).toEqual 'newValue'

		it 'allow to set html or plain text value to non-input element', ->
			control.setDomAccessor plainDomSpan
			for value in ['plain text value', '<h1><b>HTML</b> value</h1>']
				control.setValue value
				expect(control.getValue()).toEqual value

		it 'accepts only true/false for checkbox and sets its checked/unchecked state', ->
			control.setDomAccessor plainDomCheckbox

			expectedEx = new AssertException 'checkbox accepts only true/false'
			expect(-> control.setValue invalidValue).toThrow expectedEx for invalidValue in ['', null, 'some string', 1]

			control.setValue true
			expect(control.getValue()).toBeTruthy()
	
			control.setValue false
			expect(control.getValue()).toBeFalsy()

	it 'setValueChangeListener: sets listener to fire when its value changes; gives new value and itself', ->
		#TODO: проверять, что только для input элементов
		plainDomInput = $ '<input type="text"/>'
		input = new PlainDomControl

		changedElement = null
		newValue = null

		input.setDomAccessor plainDomInput
		input.setValueChangeListener (newVal, changedEl) ->
			newValue = newVal
			changedElement = changedEl

		plainDomInput.val 'new value'
		plainDomInput.change()
		expect(changedElement).toBe input

	describe 'sets event listeners through subscribeToEvent', ->
		it 'uses event names of jquery and prevents default event behaviour', ->
			control = new PlainDomControl
			domAccessor = $ '<div></div>'
			boundEvents = []
			spyOn(domAccessor, 'bind').andCallFake (eventName, handler) ->
				boundEvent = {}
				boundEvent[eventName] = handler
				boundEvents.push boundEvent

			clicked = false
			control.setDomAccessor domAccessor
			control.subscribeToEvent 'click', -> clicked = true
			expect(boundEvents.length).toEqual 1
			expect(boundEvents[0].click?).toBeTruthy()

			defaultPrevented = false

			boundEvents[0].click
				preventDefault: -> defaultPrevented = true
			expect(clicked).toBeTruthy()
			expect(defaultPrevented).toBeTruthy()
