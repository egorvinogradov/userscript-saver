describe 'PlainDomControl', ->
	describe 'getValue', ->
		it 'returns true/false for checked/unchecked checkbox', ->
			plainDomCheckbox = $ '<input type="checkbox"/>'
			checkbox = new PlainDomControl
			checkbox.setDomAccessor plainDomCheckbox

			expect(checkbox.getValue()).toEqual off

			plainDomCheckbox.attr 'checked', on
			expect(checkbox.getValue()).toEqual on

			plainDomCheckbox.attr 'checked', off
			expect(checkbox.getValue()).toEqual off

		it 'returns $val() for any input except checkbox', ->
			plainDomInput = $ '<input type="text"/>'
			input = new PlainDomControl

			input.setDomAccessor plainDomInput
			expect(input.getValue()).toEqual ''

			plainDomInput.val 'foo'
			expect(input.getValue()).toEqual 'foo'

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
