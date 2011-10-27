describe 'PlainDomControl', ->
	plainDomInput = null
	plainDomCheckbox = null
	control = null

	beforeEach ->
		plainDomCheckbox = $ '<input type="checkbox"/>'
		plainDomInput = $ '<input type="text"/>'
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

	describe 'setValue', ->
		it 'allows to set value to control', ->
			control.setDomAccessor plainDomInput
			control.setValue 'newValue'
			expect(control.getValue()).toEqual 'newValue'

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
		it 'uses event names of jquery', ->
			control = new PlainDomControl
			domAccessor = $ '<div></div>'
			control.setDomAccessor domAccessor

			clicked = false
			control.subscribeToEvent 'click', -> clicked = true

			domAccessor.click()
			expect(clicked).toBeTruthy()
