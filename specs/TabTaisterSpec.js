describe("TabTaister", function() {
	var tabTaister
	beforeEach(function() {
		tabTaister = new TabTaister()
	})
	it("subscribes to any tab change through current browser api", function() {

		var tabApi = {
			subscribeCalled: "subscribeToTabChange not called",
			subscribeToTabChange: function() {this.subscribeCalled = "subscribe called"}
		}

		tabTaister.setTabApi(tabApi)
		tabTaister.startListeningToTabChange()

		expect(tabApi.subscribeCalled).toEqual("subscribe called")
	})

	it('on tab change wraps combined taistie code in functional expression and inserts it through api', function() {
		var mockCodeToInsert = {css: 'css', js: 'js'}
		tabTaister.setTaistieCombiner({getAllCssAndJsForUrl: function() {
			return mockCodeToInsert}})

		var mockInsertFunction = function(unusedArgs) {var local = unusedArgs}
		tabTaister._insertFunction = mockInsertFunction

		var tabTaistCallBack, insertedCode, insertCalled, usedTabDescriptor

		var mockTabApi = {
			subscribeToTabChange: function(callBack){tabTaistCallBack = callBack},
			insertJsToTab: function(jsCode, tabDescriptor) {
				insertCalled = true
				usedTabDescriptor = tabDescriptor
				insertedCode = jsCode
			}
		}
		tabTaister.setTabApi(mockTabApi)
		tabTaister.startListeningToTabChange()

		tabTaistCallBack("unused url", "checked tab descriptor")
		expect(insertCalled).toBeTruthy()
		expect(usedTabDescriptor).toEqual("checked tab descriptor")
		expect(insertedCode).toEqual('(' + mockInsertFunction.toString() + ')(' + JSON.stringify(mockCodeToInsert) + ')')
	})

	it('skips both empty js and css', function() {

	})
})