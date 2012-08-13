Taist = {
  taisties: []
  utils:
    getTaistiesUrl: ->
      # 'http://www.tai.st/server/taisties/' + document.location.hostname.replace(/www\./, '')
      'http://127.0.0.1:3000/server/taisties/' + document.location.hostname.replace(/www\./, '')

    getTaistieState: (id) ->
      localStorage.getItem this.tmpl('taist_taistie_#{id}_state', { id: id })

    setTaistieState: (id, state) ->
      localStorage.setItem this.tmpl('taist_taistie_#{id}_state', { id: id }), state

    sendError: (id, data) ->
      console and console.error and console.error 'Taistie error (id: ' + id + ')', data

    tmpl: (template, data) ->
      placeHolderRegExp = /#\{(?:\s+)?([a-zA-Z0-9_]+)(?:\s+)?\}/g
      replace = (str, property) -> data[property] or ''
      template.replace(placeHolderRegExp, replace);

  init: ->
    $('<script></script>')
      .attr({ src: this.utils.getTaistiesUrl()})
        .appendTo('body');

  applyTaisties: (data) ->
    for taistie in data
      scriptData = {
        jsCode: taistie.js,
        jsVars: this.utils.tmpl('{ id: #{id}, name: "#{name}", description: "#{description}" }', taistie)
      }
      this.taisties.push(taistie);
      if not this.utils.getTaistieState taistie.id
        this.utils.setTaistieState taistie.id, 'active'

      $('<script></script>').html this.utils.tmpl('(function(taistie){#{jsCode}}(#{jsVars}))', scriptData)
        .appendTo 'body'
      $('<style></style>').html taistie.css
        .appendTo 'head'
}

Taist.init()
