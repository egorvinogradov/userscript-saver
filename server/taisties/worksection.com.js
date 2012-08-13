if ( !console || !console.log ) {
    console = {
        log: function(){}
    };
}

var taistie = typeof taistie !== 'undefined' ? taistie : null,
    isActive = function(){
        return Taist.utils.getTaistieState(taistie.id) === 'active';
    };

console.log('Taist: start', taistie);



Taist.MassReassignment = {
    els: {},
    selectors: {
        tabContainer: '#title_tabs',
        tabs: '#title_tabs a'
    },
    classes: {},
    config: {
        tabText: 'Массовое перегазначение',
        tabHash: '#reassingnment',
        tabActiveClass: 'act',
        initialRel: 'initial'
    },
    init: function(){

        console.log('init');

        this.els.tabContainer = $(this.selectors.tabContainer);
        this.els.button = $(Taist.utils.tmpl('<a href="/profile/#{tabHash}">#{tabText}</a>', this.config));
        this.els.tabs = $(this.selectors.tabs);
        this.els.tabContainer.append(this.els.button);

        this.els.tabs
            .filter('.' + this.config.tabActiveClass)
            .attr({ rel: 'initial' });

        this.render();

        this.els.button.on('click', $.proxy(this.show, this));
        this.els.tabs
            .not(this.els.button)
            .on('click', $.proxy(this.hide, this));

        document.location.hash === this.config.tabHash
            ? this.show()
            : this.hide();

    },
    render: function(){

        console.log('render');


    },
    show: function(){

        console.log('show');

        this.els.tabs.removeClass(this.config.tabActiveClass);
        this.els.button.addClass(this.config.tabActiveClass);

        // show block

    },
    hide: function(){

        console.log('hide');

        this.els.tabs
            .removeClass(this.config.tabActiveClass)
            .filter('[rel="' + this.config.initialRel + '"]')
            .addClass(this.config.tabActiveClass);

        // hide block

    }
};



Taist.Tests = {
    pages: {
        massReassignment: {
            path: /^\/(?:profile|profile_tune)(?:\/)?$/,
            method: Taist.MassReassignment,
            selectors: {
                titleTabs: '#title_tabs'
            }
        }
    },
    init: function(){

        var nodes = this.checkNodes();

        if ( nodes.status !== 'ok' ) {

            Taist.utils.sendError(taistie.id, {
                testType: 'checkNodes',
                errorMessage: nodes.message,
                errorData: nodes.data,
                browser: navigator.userAgent
            });
        }
        else {

            for ( var page in this.pages ) {
                if ( this.pages[page].path.test(document.location.pathname) ) {
                    this.pages[page].method.init();
                    break;
                }
            }
        }
    },
    checkNodes: function(){

        var checkNested = function(element, parent){

            var parent = parent || document,
                container = element.container ? $(element.container, parent) : $('body', parent),
                selectors = element.selectors;

            console.log('\n--- Beginning >',
                '\n     container:', element.container, container.length,
                '\n     parent:', parent,
                '\n     selectors:', selectors
            );

            if ( container.length ) {

                for ( var s in selectors ) {

                    var nested = selectors[s];

                    console.log('\n--- Type of nested >',
                        '\n     nested:', nested,
                        '\n     typeof nested:', typeof nested,
                        '\n     nested name:', s);

                    if ( typeof nested === 'string' ) {

                        container.each(function(i, e){
                            var _container = $(e);
                            if ( !_container.find(nested).length ) {
                                generateError(nested, _container.attr('class'));
                            }
                            else {
                                console.log('\n--- Nested is ELEMENT >',
                                    '\n     container:', element.container,
                                    '\n     nested:', nested,
                                    '\n     container element:', _container,
                                    '\n     nested element:', _container.find(nested));
                            }
                        });
                    }
                    else {

                        if ( nested instanceof Object &&
                             nested.container &&
                             nested.selectors )
                        {
                            console.log('\n--- Nested is COLLECTION >',
                                '\n     container:', element.container,
                                '\n     nested:', nested,
                                '\n     nested.container:', nested.container,
                                '\n     nested.container element:', $(nested.container),
                                '\n     nested.selectors:', nested.selectors);

                            checkNested(nested, container);
                        }
                    }
                }
            }
            else {
                generateError(element.container, parent);
            }
        },
        generateError = function(selector, container){
            return {
                status: 'failed',
                message: 'node doesn\'t exist',
                data: {
                    selector: selector,
                    container: container
                }
            }
        };

        for ( var page in this.pages ) {
            if ( this.pages[page].path.test(document.location.pathname) ) {
                checkNested({
                    container: 'body',
                    selectors: this.pages[page].selectors
                });
            }
        }

        return {
            status: 'ok'
        }

    }
};

Taist.Tests.init();
