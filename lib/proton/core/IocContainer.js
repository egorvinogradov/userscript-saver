IocContainer = function(){
	this._createdElements = {}
}

IocContainer.prototype.setSchema = function(schema){
	this._schema = schema
}

IocContainer.prototype.getElement = function(elementName){
	var previouslyCreatedElement = this._createdElements[elementName]

	return previouslyCreatedElement !== undefined
			? previouslyCreatedElement
			: this._getNewElement(elementName)
}

IocContainer.prototype._getNewElement = function (elementName) {
	var elementDescriptor = this._getElementDescriptor(elementName)

	var element = this._createElement(elementDescriptor)

	var dependencies = elementDescriptor.dependencies
	if (dependencies !== undefined) {
		for (var dependencyName in elementDescriptor.dependencies) {
			element[dependencyName] = this.getElement(elementDescriptor.dependencies[dependencyName])
		}
	}

	this._createdElements[elementName] = element
	return element
}

IocContainer.prototype._getElementDescriptor = function(elementName) {
	assert(this._schema !== undefined, 'Dependency schema is not set')
	var elementDescriptor = this._schema[elementName]

	assert(elementDescriptor !== undefined, 'Element \'' + elementName + '\' not found in dependency schema')

	return elementDescriptor
}

IocContainer.prototype._createElement = function(elementDescriptor) {
	if(elementDescriptor.ctor !== undefined) {
		return 	new elementDescriptor.ctor
	}

	if(elementDescriptor.reference !== undefined) {
		return elementDescriptor.reference
	}
}