(window ? exports).expectAssertFail = (assertionMessage, func) ->
	expect(func).toThrow new AssertException assertionMessage
