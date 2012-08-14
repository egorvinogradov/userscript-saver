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
        tabs: {
            container: '#title_tabs',
            items: '#title_tabs a'
        },
        tasks: {
            ajaxContainer: '',
            container: '#tasks'
        }
    },
    classes: {
        tasks: {
            ajaxContainer: 'taist__ajax-container'
        }
    },
    config: {
        tab: {
            // text: 'Массовое переназначение',
            text: 'Mass reassignment',
            hash: '#reassingnment',
            rel: 'reassignment',
            activeClass: 'act',
            initialRel: 'initial'
        },
        tasks: {
            url: '/ajax/?action=my_tasks',
            load: '/ajax/?action=my_tasks .list',
            ajaxSelectors: {
                projects: '.indrop > div',
                projectName: '.proj',
                tasks: '.list > div',
                taskName: '.list a',
                taskPriority: '.list .priorb',
                users: 'select[name="seluser"] option'
            }
        }
    },
    templates: {
        tabs: {
            item: '<\a rel="#{rel}" href="/profile/#{hash}">#{text}<\/a>'
        },
        tasks: {
            wrapper: '<\div class="task task1st">#{html}<\/div>',
            ajaxContainer: '<\div class="#{ajaxContainer} taist_hidden"><\/div>'
        }
    },
    init: function(){

        $.extend({
            proxy: function(func, context){
                return function(){
                    func.apply(context, arguments);
                };
            },
            tmpl: Taist.utils.tmpl
        });
        
        this.detach();
        this.getNodesFromSelectors(this.selectors, this.els);
        

        this.els.tabs.button = $($.tmpl(this.templates.tabs.item, this.config.tabs));
        this.els.tabs.container.append(this.els.tabs.button);

        this.render( this.getData() );

        this.els.tabs.items
            .filter('.' + this.config.tabs.activeClass)
            .attr({ rel: this.config.tabs.initialRel });

        this.els.tabs.button
            .unbind('click')
            .bind('click', $.proxy(this.show, this));

        this.els.tabs.items
            .not(this.els.tabs.button)
            .unbind('click')
            .bind('click', $.proxy(this.hide, this));

        if ( document.location.hash === this.config.tabs.hash ) {
            this.show();
        }

    },
    getNodesFromSelectors: function(selectors, nodes){
        
        var iterateSelectors = function(obj, parent){
            for ( var key in obj ) {
                var value = obj[key];
                parent = parent || nodes;
                if ( typeof value === 'string' ) {
                    parent[key] = $(value);
                }
                else {
                    parent[key] = {};
                    iterateSelectors(value, parent[key]);
                }
            }
        };
        iterateSelectors(selectors, nodes);
        return nodes;

    },
    getData: function(){

        console.log('get data');

        var config = this.config.tasks.ajaxSelectors,
            getProjects = function(container){

                var projects = [];

                container.find(config.projects).each(function(i, e){

                    var project = {},
                        el = $(e);

                    project.name = $.trim( el.find(config.projectName).html().replace(/(<.+>)/ig, '') );
                    project.href = el.attr('href');
                    project.tasks = getTasks(el.find(config.tasks));
                    projects.push(project);
                });

                return projects;

            },
            getTasks = function(container){

                var projects = [],
                    tasks = [];

                container.find(config.tasks).each(function(i, e){

                    var task = {},
                        el = $(e),
                        name = el.find(config.taskName),
                        priority = el.find(config.taskPriority);

                    task.href = name.attr('href');
                    task.priority = +priority.html();
                    task.name = $.trim( name.html().replace(/(<.+>)/ig, '') );
                    tasks.push(task);
                });

                return tasks;

            },
            getUsers = function(container){

                var users = [];

                container.find(config.users).each(function(i,e){

                    var user = {},
                        el = $(e);

                    user.name = el.html();
                    user.id = el.attr('value');
                    users.push(user);
                });

                return users;

            },
            tasks,
            users;


        this.els.tasks.ajaxContainer = $($.tmpl(this.templates.tasks.ajaxContainer, this.classes.tasks));

        this.els.tasks.ajaxContainer
            .appendTo(this.els.tasks.container)
            .load(this.config.tasks.load);


        tasks = getProjects(this.els.tasks.ajaxContainer);
        users = getUsers(this.els.tasks.ajaxContainer);

        return {
            tasks: tasks,
            users: users
        };

    },

    render: function(data){

        console.log('>>> render', data);

    },
    show: function(){

        console.log('show');

        this.els.tabs.removeClass(this.config.tabs.activeClass);
        this.els.button.addClass(this.config.tabs.activeClass);

        // show block

    },
    hide: function(){

        console.log('hide');

        this.els.tabs
            .removeClass(this.config.tabs.activeClass)
            .filter($.tmpl('[rel="#{initialRel}"]', this.config.tabs))
            .addClass(this.config.tabs.activeClass);

        // hide block

    },
    detach: function(){

        console.log('detach');

        $(this.selectors.tabs)
            .filter($.tmpl('[rel="#{rel}"]', this.config.tabs))
            .remove();

        // todo: remove block

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
