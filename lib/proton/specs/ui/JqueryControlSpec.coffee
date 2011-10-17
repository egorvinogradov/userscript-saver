describe 'JqueryControl', ->
	describe 'getValue', ->
		it 'returns true/false for checked/unchecked checkbox', ->
			jqueryCheckbox = $ '<input type="checkbox"/>'
			checkbox = new JqueryControl
			checkbox.setJqueryElement jqueryCheckbox

			expect(checkbox.getValue()).toEqual off

			jqueryCheckbox.attr 'checked', on
			expect(checkbox.getValue()).toEqual on

			jqueryCheckbox.attr 'checked', off
			expect(checkbox.getValue()).toEqual off

		it 'returns $val() for any input except checkbox', ->
			jqueryInput = $ '<input type="text"/>'
			input = new JqueryControl

			input.setJqueryElement jqueryInput
			expect(input.getValue()).toEqual ''

			jqueryInput.val 'foo'
			expect(input.getValue()).toEqual 'foo'

	it 'setValueChangeListener: sets listener to fire when its value changes; gives itself and new value', ->
		#TODO: проверять, что только для input элементов
		jqueryInput = $ '<input type="text"/>'
		input = new JqueryControl

		changedElement = null
		newValue = null

		input.setJqueryElement jqueryInput
		input.setValueChangeListener (changedEl, newVal) ->
			changedElement = changedEl
			newValue = newVal

		jqueryInput.val 'new value'
		jqueryInput.change()
		expect(changedElement).toBe input
