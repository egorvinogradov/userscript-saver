(function() {

    var Taist = {
        url: 'http://www.tai.st/server/taisties/youscan.ru',
        taisties: [],
        init: function(){
            document.body.appendChild(this.createEl('script', {
                src: this.url,
                type: 'text/javascript',
                defer: 'defer',
                async: true
            }));
        },
        applyTaisties: function(data){
            for ( var i = 0, l = data.length; i < l; i++ ) {
                var params = '{\"id\":\"' + data[i].id + '\",\"name\":\"' + data[i].name + '\",\"description\":\"' + data[i].description + '\"}';
                document.head.appendChild(this.createEl('style', {
                    type: 'text/css',
                    innerHTML: data[i].css
                }));
                document.body.appendChild(this.createEl('script', {
                    type: '',
                    innerHTML: '(function(taistie){' + data[i].js + '}(' + params + '))'
                }));
                this.taisties.push(data[i]);
            }
        },
        createEl: function(tagName, attributes){
            var el = document.createElement(tagName);
            for ( var a in attributes ) {
                el[a] = attributes[a];
            }
            return el;
        }
    };

    if ( localStorage.getItem('taist_taistieState') ) {
        localStorage.setItem('taist_taistieState', 'active');
    }

    Taist.init();
    window.Taist = Taist;

})();
