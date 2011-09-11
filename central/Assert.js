AssertException = function (message) {
	this.message = message
}
AssertException.prototype.toString = function () {
	return 'AssertException: ' + this.message
}

function assert(conditionalExpression, message) {
	if (!conditionalExpression) {
		throw new AssertException(message)
	}
}