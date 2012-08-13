(function() {
  var Taist;

  Taist = {
    taisties: [],
    utils: {
      getTaistiesUrl: function() {
        return 'http://127.0.0.1:3000/server/taisties/' + document.location.hostname.replace(/www\./, '');
      },
      getTaistieState: function(id) {
        return localStorage.getItem(this.tmpl('taist_taistie_#{id}_state', {
          id: id
        }));
      },
      setTaistieState: function(id, state) {
        return localStorage.setItem(this.tmpl('taist_taistie_#{id}_state', {
          id: id
        }), state);
      },
      sendError: function(id, data) {
        return console && console.error && console.error('Taistie error (id: ' + id + ')', data);
      },
      tmpl: function(template, data) {
        var placeHolderRegExp, replace;
        placeHolderRegExp = /#\{(?:\s+)?([a-zA-Z0-9_]+)(?:\s+)?\}/g;
        replace = function(str, property) {
          return data[property] || '';
        };
        return template.replace(placeHolderRegExp, replace);
      }
    },
    init: function() {
      return $('<script></script>').attr({
        src: this.utils.getTaistiesUrl()
      }).appendTo('body');
    },
    applyTaisties: function(data) {
      var scriptData, taistie, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        taistie = data[_i];
        scriptData = {
          jsCode: taistie.js,
          jsVars: this.utils.tmpl('{ id: #{id}, name: "#{name}", description: "#{description}" }', taistie)
        };
        this.taisties.push(taistie);
        if (!this.utils.getTaistieState(taistie.id)) {
          this.utils.setTaistieState(taistie.id, 'active');
        }
        $('<script></script>').html(this.utils.tmpl('(function(taistie){#{jsCode}}(#{jsVars}))', scriptData).appendTo('body'));
        _results.push($('<style></style>').html(taistie.css.appendTo('head')));
      }
      return _results;
    }
  };

  Taist.init();

}).call(this);
