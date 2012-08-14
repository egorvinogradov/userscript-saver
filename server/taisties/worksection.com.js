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





var MassReassignment = function() {

    this.settings = {
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
            tabs: {
                active: 'act'
            },
            tasks: {
                ajaxContainer: 'taist__ajax-container'
            }
        },
        config: {
            tabs: {
                // text: 'Массовое переназначение', // todo: resolve encoding problem
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
        }
    };
};


MassReassignment.prototype.init = function(){

    $.extend({
        proxy: function(func, context){
            return function(){
                func.apply(context, arguments);
            };
        },
        tmpl: Taist.utils.tmpl
    });

    this.detach();

    this.els = this.getNodesFromSelectors(this.settings.selectors);
    this.els.tabs.button = $($.tmpl(this.settings.templates.tabs.item, this.settings.config.tabs));
    this.els.tabs.container.append(this.els.tabs.button);

    this.render( this.getData() );

    this.els.tabs.button
        .unbind('click')
        .bind('click', $.proxy(this.show, this));

    if ( document.location.hash === this.settings.config.tabs.hash ) {
        this.show();
    }
};


MassReassignment.prototype.getNodesFromSelectors = function(selectors){

    var nodes = {},
        iterateSelectors = function(obj, parent){
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
};


MassReassignment.prototype.getData = function(){

    var selectors = this.settings.config.tasks.ajaxSelectors,
        getTasks = function(container){

            var projects = [];

            container.find(selectors.projects).each(function(i, e){

                var project = {},
                    el = $(e);

                project.name = $.trim( el.find(selectors.projectName).html().replace(/(<.+>)/ig, '') );
                project.href = el.attr('href');
                project.tasks = getTasksOfProject(el.find(selectors.tasks));
                projects.push(project);
            });

            return projects;

        },
        getTasksOfProject = function(container){

            var tasks = [];

            container.find(selectors.tasks).each(function(i, e){

                var task = {},
                    el = $(e),
                    name = el.find(selectors.taskName),
                    priority = el.find(selectors.taskPriority);

                task.href = name.attr('href');
                task.priority = +priority.html();
                task.name = $.trim( name.html().replace(/(<.+>)/ig, '') );
                tasks.push(task);
            });

            return tasks;

        },
        getUsers = function(container){

            var users = [];

            container.find(selectors.users).each(function(i,e){

                var user = {},
                    el = $(e);

                user.name = el.html();
                user.id = el.attr('value');
                users.push(user);
            });

            return users;

        };

    this.els.tasks.ajaxContainer = $( $.tmpl(this.settings.templates.tasks.ajaxContainer, this.settings.classes.tasks) );

    this.els.tasks.ajaxContainer
        .appendTo(this.els.tasks.container)
        .load(this.settings.config.tasks.load);

    return {
        tasks: getTasks(this.els.tasks.ajaxContainer),
        users: getUsers(this.els.tasks.ajaxContainer)
    };
};


MassReassignment.prototype.render = function(data){

    console.log('>>> render', data);

    // todo: make render

};


MassReassignment.prototype.show = function(){

    console.log('show');

    this.els.tabs.items.removeClass(this.settings.classes.tabs.active);
    this.els.tabs.button.addClass(this.settings.classes.tabs.active);

    // show block

};


MassReassignment.prototype.detach = function(){

    console.log('detach');

    var tabsConfig = this.settings.config.tabs,
        tabsClasses = this.settings.classes.tabs,
        tabs = {};

    tabs.all = $(this.settings.selectors.tabs.items);
    tabs.reassignment = tabs.all.filter($.tmpl('[rel="#{rel}"]', tabsConfig));
    tabs.initial = tabs.all.not(tabs.reassignment);
    tabs.firstSelected = tabs.initial.filter($.tmpl('[rel="#{initialRel}"]', tabsConfig));

    if ( !tabs.firstSelected.length ) {
        tabs.firstSelected = tabs.initial.filter('.' + tabsClasses.active);
        tabs.firstSelected.attr({ rel: tabsConfig.initialRel });
    }
    else {
        tabs.all.removeClass(tabsClasses.active);
        tabs.firstSelected.addClass(tabsClasses.active);
    }

    tabs.reassignment.remove();

    // todo: remove block
};


Taist.MassReassignment = new MassReassignment();
//Taist.MassReassignment.init();






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
