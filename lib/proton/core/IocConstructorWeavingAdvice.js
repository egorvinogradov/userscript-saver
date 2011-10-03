IocConstructorWeavingAdvice = function(){}

IocConstructorWeavingAdvice.prototype.execute = function(weaver, aspectSchema) {
	weaver.before('_createFromConstructor', this.applyAspectsToConstructor)
}

IocConstructorWeavingAdvice.prototype.applyAspectsToConstructor = function() {}