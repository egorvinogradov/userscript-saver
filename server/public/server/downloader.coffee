Taist = {
  taisties: []
  utils:
    getTaistiesUrl: ->
      # 'http://www.tai.st/server/taisties/' + location.hostname.replace /(?:[a-z0-9\-]+\.)*?([a-z0-9\-]+\.[a-z]{2,4})$/i, '$1'
      'http://127.0.0.1:3000/server/taisties/' + location.hostname.replace /(?:[a-z0-9\-]+\.)*?([a-z0-9\-]+\.[a-z]{2,4})$/i, '$1'

    getTaistieState: (id) ->
      localStorage.getItem @tmpl('taist_taistie_#{id}_state', { id: id })

    setTaistieState: (id, state) ->
      localStorage.setItem @tmpl('taist_taistie_#{id}_state', { id: id }), state

    sendError: (id, data) ->
      window.console and window.console.error and console.error 'Taistie error (id: ' + id + ')', data

    tmpl: (template, data) ->
      data = data || {};
      placeHolderRegExp = /#\{(?:\s+)?([a-zA-Z0-9_]+)(?:\s+)?\}/g
      replace = (str, property) -> data[property] or ''
      template.replace placeHolderRegExp, replace

    createEl: (tagName, attributes) ->
      el = document.createElement tagName
      for key of attributes
        el[key] = attributes[key]
      el

  init: ->
    script = @utils.createEl 'script',
      src: @utils.getTaistiesUrl()
    document.body.appendChild script

  applyTaisties: (data) ->

    for taistie in data

      scriptData =
        jsCode: taistie.js
        jsVars: @utils.tmpl '{ id: #{id}, name: "#{name}", description: "#{description}" }', taistie

      scriptEl = @utils.createEl 'script',
        innerHTML: @utils.tmpl '(function(taistie){#{jsCode}}(#{jsVars}))', scriptData

      styleEl = @utils.createEl 'style',
        innerHTML: taistie.css

      @taisties.push taistie
      if not @utils.getTaistieState taistie.id
        @utils.setTaistieState taistie.id, 'active'

      document.body.appendChild scriptEl
      document.head.appendChild styleEl
    return
}

Taist.init()
