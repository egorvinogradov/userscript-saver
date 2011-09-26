JqueryButton = function(){
}

JqueryButton.prototype.render = function(tagName){
	$('body').append($('<' + tagName + '>'))
}