$ = jQuery

class Taistie extends Spine.Model
  @configure "Taistie", "name", "done"
  
  @extend Spine.Model.Local

  @active: ->
    @select (item) -> !item.done

  @done: ->
    @select (item) -> !!item.done

  @destroyDone: ->
    rec.destroy() for rec in @done()

class Tasks extends Spine.Controller
  events:
   "change   input[type=checkbox]": "toggle"
   "click    .destroy":             "remove"
   "dblclick .view":                "edit"
   "keypress input[type=text]":     "blurOnEnter"
   "blur     input[type=text]":     "close"
 
  elements:
    "input[type=text]": "input"

  constructor: ->
    super
    @item.bind("update",  @render)
    @item.bind("destroy", @release)
  
  render: =>
    @replace($("#taskTemplate").tmpl(@item))
    @
  
  toggle: ->
    @item.done = !@item.done
    @item.save()
  
  remove: ->
    @item.destroy()
  
  edit: ->
    @el.addClass("editing")
    @input.focus()
  
  blurOnEnter: (e) ->
    if e.keyCode is 13 then e.target.blur()
  
  close: ->
    @el.removeClass("editing")
    @item.updateAttributes({name: @input.val()})

class TaskApp extends Spine.Controller
  events:
    "submit form":   "create"
    "click  .clear": "clear"

  elements:
    ".items":     "items"
    ".countVal":  "count"
    ".clear":     "clear"
    "form input": "input"
  
  constructor: ->
    super
    Taistie.bind("create",  @addOne)
    Taistie.bind("refresh", @addAll)
    Taistie.bind("refresh change", @renderCount)
    Taistie.fetch()
  
  addOne: (task) =>
    view = new Tasks(item: task)
    @items.append(view.render().el)
  
  addAll: =>
    Taistie.each(@addOne)

  create: (e) ->
    e.preventDefault()
    Taistie.create(name: @input.val())
    @input.val("")
  
  clear: ->
    Taistie.destroyDone()
  
  renderCount: =>
    active = Taistie.active().length
    @count.text(active)
    
    inactive = Taistie.done().length
    if inactive 
      @clear.show()
    else
      @clear.hide()

$ ->
  new TaskApp(el: $("#tasks"))
