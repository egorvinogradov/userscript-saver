$(function() {

	var iocContainer = new IocContainer()
	iocContainer.setSchema({
		optionsRoot: OptionsRoot()
	})

	var optionsRoot = iocContainer.getElement('optionsRoot')
	optionsRoot.init($('body'))
})