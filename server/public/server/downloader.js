var Taist = {
    taisties: [],
    utils: {
        getTaistiesUrl: function(){
            //return 'http://www.tai.st/server/taisties/' + document.location.hostname.replace(/www\./, '');
            return 'http://127.0.0.1:3000/server/taisties/' + document.location.hostname.replace(/www\./, '');
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
        tmpl: function(template, data){
            var re = /#\{(?:\s+)?([a-zA-Z0-9_]+)(?:\s+)?\}/g,
                replace = function(str, property){
                    return data[property] || '';
                };
            return template.replace(re, replace);
        }
    },
    init: function(){

        $('<script></script>')
            .attr({ src: this.utils.getTaistiesUrl() })
            .appendTo('body');
    },
    applyTaisties: function(data){

        for ( var i = 0, l = data.length; i < l; i++ ) {

            var taistie = data[i],
                scriptData = {
                    jsCode: taistie.js,
                    jsVars: this.utils.tmpl('{ id: #{id}, name: "#{name}", description: "#{description}" }', taistie)
                };

            this.taisties.push(data[i]);

            if ( !this.utils.getTaistieState(taistie.id) ) {
                this.utils.setTaistieState(taistie.id, 'active');
            }

            $('<script></script>').html(this.utils.tmpl('(function(taistie){#{jsCode}}(#{jsVars}))', scriptData)).appendTo('body');
            $('<style></style>').html(taistie.css).appendTo('head');

        }
    }
};

Taist.init();
