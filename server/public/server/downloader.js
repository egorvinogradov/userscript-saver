var Taist = {
    taisties: [],
    utils: {
        getTaistiesUrl: function(){
            return 'http://127.0.0.1:3000/server/taisties/' + location.hostname.replace(/(?:[a-z0-9\-]+\.)*?([a-z0-9\-]+\.[a-z]{2,4})$/i, '$1');
        },
        getTaistieState: function(id){
            return localStorage.getItem(
                this.tmpl('taist_taistie_#{id}_state', { id: id })
            );
        },
        setTaistieState: function(id, state){
            localStorage.setItem(
                this.tmpl('taist_taistie_#{id}_state', { id: id }),
                state
            );
        },
        sendError: function(id, data){
            console && console.error && console.error('Taistie error (id: ' + id + ')', data);
        },
        createEl: function(tagName, attributes){
            var el = document.createElement(tagName);
            for ( var key in attributes ) {
                el[key] = attributes[key];
            }
            return el;
        },
        tmpl: function(template, data){
            data = data || {};
            var re = /#\{(?:\s+)?([a-zA-Z0-9_]+)(?:\s+)?\}/g,
                replace = function(str, property){
                    return data[property] || '';
                };
            return template.replace(re, replace);
        }
    },
    init: function(){
        var script = this.utils.createEl('script', {
            src: this.utils.getTaistiesUrl()
        });
        document.body.appendChild(script);
    },
    applyTaisties: function(data){
        for ( var i = 0, l = data.length; i < l; i++ ) {
            var taistie = data[i],
                scriptData = {
                    jsCode: taistie.js,
                    jsVars: this.utils.tmpl('{ id: #{id}, name: "#{name}", description: "#{description}" }', taistie)
                },
                scriptEl = this.utils.createEl('script', {
                    innerHTML: this.utils.tmpl('(function(taistie){#{jsCode}}(#{jsVars}))', scriptData)
                }),
                styleEl = this.utils.createEl('style', {
                    innerHTML: taistie.css
                });

            document.body.appendChild(scriptEl);
            document.head.appendChild(styleEl);

            this.taisties.push(data[i]);

            if ( !this.utils.getTaistieState(taistie.id) ) {
                this.utils.setTaistieState(taistie.id, 'active');
            }
        }
    }
};

Taist.init();
