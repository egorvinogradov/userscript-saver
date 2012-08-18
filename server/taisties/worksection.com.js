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
                editForm: '#edit_form',
                container: '#tasks',
                reassignment: {
                    container: '.taist-mass-reassignment',
                    projects: {
                        item: '.taist-mass-reassignment__project',
                        input: '.taist-mass-reassignment__project-title-checkbox'
                    },
                    tasks: {
                        item: '.taist-mass-reassignment__task-item',
                        input: '.taist-mass-reassignment__task-item-checkbox'
                    }
                }
            }
        },
        classes: {
            tabs: {
                active: 'act'
            },
            tasks: {
                ajaxContainer: 'taist-mass-reassignment__ajax-container'
            }
        },
        config: {
            tabs: {
                hash: '#reassingnment',
                rel: 'reassignment',
                activeClass: 'act',
                initialRel: 'initial'
            },
            tasks: {
                url: '/ajax/?action=my_tasks',
                ajaxSelectors: {
                    projects: '.indrop > div',
                    projectName: '.proj',
                    tasks: '.list > div',
                    taskName: '> a',
                    taskPriority: '.priorb',
                    users: 'select[name="seluser"] option'
                }
            }
        },
        templates: {
            tabs: {
                link: decodeURIComponent('%3Ca%20rel%3D%22%23%7Brel%7D%22%20href%3D%22%2Fprofile%2F%23%7Bhash%7D%22%3E%D0%9F%D0%B5%D1%80%D0%B5%D0%BD%D0%B0%D0%B7%D0%BD%D0%B0%D1%87%D0%B8%D1%82%D1%8C%20%D0%B7%D0%B0%D0%B4%D0%B0%D1%87%D0%B8%3C%2Fa%3E')
            },
            tasks: {
                container: decodeURIComponent('%3Cdiv%20class%3Dtaist-mass-reassignment%3E%3Cdiv%20class%3Dtaist-mass-reassignment__user%3E%3Cspan%20class%3Dtaist-mass-reassignment__user-text%3E%D0%9F%D0%B5%D1%80%D0%B5%D0%BD%D0%B0%D0%B7%D0%BD%D0%B0%D1%87%D0%B8%D1%82%D1%8C%20%D0%BD%D0%B0%20%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D0%BE%D0%B2%D0%B0%D1%82%D0%B5%D0%BB%D1%8F%3C%2Fspan%3E%3Cselect%20class%3Dtaist-mass-reassignment__user-select%3E%23%7Busers%7D%3C%2Fselect%3E%3Cbutton%20class%3Dtaist-mass-reassignment__user-button%3E%D0%93%D0%BE%D1%82%D0%BE%D0%B2%D0%BE%3C%2Fbutton%3E%3C%2Fdiv%3E%3Cdiv%20class%3Dtaist-mass-reassignment__tasks%3E%23%7Bprojects%7D%3C%2Fdiv%3E%3C%2Fdiv%3E'),
                user: decodeURIComponent('%3Coption%20value%3D%22%23%7BuserId%7D%22%3E%23%7BuserName%7D%3C%2Foption%3E'),
                project: decodeURIComponent('%3Cdiv%20class%3Dtaist-mass-reassignment__project%20data-id%3D%22%23%7BprojectId%7D%22%3E%3Cdiv%20class%3Dtaist-mass-reassignment__project-title%3E%3Cspan%20class%3Dtaist-mass-reassignment__project-title-checkbox-wrapper%3E%3Cinput%20class%3Dtaist-mass-reassignment__project-title-checkbox%20type%3Dcheckbox%3E%3C%2Fspan%3E%3Ca%20href%3D%22%2Fproject%2F%23%7BprojectId%7D%2F%22%20class%3Dtaist-mass-reassignment__project-title-link%3E%23%7BprojectName%7D%3C%2Fa%3E%3C%2Fdiv%3E%3Cul%20class%3Dtaist-mass-reassignment__task-list%3E%23%7Btasks%7D%3C%2Ful%3E%3C%2Fdiv%3E'),
                task: decodeURIComponent('%3Cli%20class%3Dtaist-mass-reassignment__task-item%20data-id%3D%22%23%7BtaskId%7D%22%3E%3Cspan%20class%3Dtaist-mass-reassignment__task-item-checkbox-wrapper%3E%3Cinput%20class%3Dtaist-mass-reassignment__task-item-checkbox%20type%3Dcheckbox%3E%3C%2Fspan%3E%3Ca%20href%3D%22%2Fproject%2F%23%7BprojectId%7D%2F%23%7BtaskId%7D%2F%22%20class%3Dtaist-mass-reassignment__task-item-link%3E%23%7BtaskName%7D%3Cspan%20title%3D%22%D0%9F%D1%80%D0%B8%D0%BE%D1%80%D0%B8%D1%82%D0%B5%D1%82%3A%20%23%7BtaskPriority%7D%22%20class%3D%22taist-mass-reassignment__task-priority%20taist-mass-reassignment__task-priority_value_%23%7BtaskPriority%7D%22%3E%23%7BtaskPriority%7D%3C%2Fspan%3E%3C%2Fa%3E%3C%2Fli%3E'),
                ajaxContainer: decodeURIComponent('%3Cdiv%20class%3D%22%23%7BajaxContainer%7D%20taist-mass-reassignment_hidden%22%3E%3C%2Fdiv%3E')
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
    this.els.tabs.button = $($.tmpl(this.settings.templates.tabs.link, this.settings.config.tabs));
    this.els.tabs.container.append(this.els.tabs.button);

    this.getData($.proxy(this.render, this));

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


MassReassignment.prototype.getData = function(callback){

    var selectors = this.settings.config.tasks.ajaxSelectors,
        getProjects = function(container){

            var projects = [];

            container.find(selectors.projects).each(function(i, e){

                var project = {},
                    el = $(e),
                    name = el.find(selectors.projectName);

                project.name = $.trim( name.html().replace(/(<.+>)/ig, '') );
                project.id = +name.attr('href').replace(/\/project\/([0-9]+)\//, '$1');
                project.tasks = getTasks(el);
                projects.push(project);
            });

            return projects;

        },
        getTasks = function(container){

            var tasks = [];

            container.find(selectors.tasks).each(function(i, e){

                var task = {},
                    el = $(e),
                    name = el.find(selectors.taskName),
                    priority = el.find(selectors.taskPriority);

                task.id = +name.attr('href').replace(/\/project\/[0-9]+\/([0-9]+)\//, '$1');
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
                user.id = +el.attr('value');
                users.push(user);
            });

            return users;

        };

    this.els.tasks.ajaxContainer = $( $.tmpl(this.settings.templates.tasks.ajaxContainer, this.settings.classes.tasks) );
    this.els.tasks.ajaxContainer
        .prependTo(this.els.tasks.container)
        .load(this.settings.config.tasks.url, $.proxy(function(){
            callback ({
                projects: getProjects(this.els.tasks.ajaxContainer),
                users: getUsers(this.els.tasks.ajaxContainer)
            });
        }, this));
};


MassReassignment.prototype.render = function(data){

    console.log('render:', data);

    var taskClasses = this.settings.classes.tasks,
        taskTemplates = this.settings.templates.tasks,
        users = [],
        projects = [],
        container;

    $.each(data.users, function(i, user){
        users.push($.tmpl(taskTemplates.user, {
            userId: user.id,
            userName: user.name
        }));
    });

    $.each(data.projects, function(i, project){

        var tasks = [];

        $.each(project.tasks, function(i, task){
            tasks.push($.tmpl(taskTemplates.task, {
                taskName:       task.name,
                taskPriority:   task.priority,
                taskId:         task.id,
                projectId:      project.id,
                name: task.name
            }));
        });

        projects.push($.tmpl(taskTemplates.project, {
            projectId:      project.id,
            projectName:    project.name,
            tasks: tasks.join('\n')
        }));
    });

    container = $.tmpl(taskTemplates.container, {
        users: users.join('\n'),
        projects: projects.join('\n')
    });

    this.els.tasks.container.append(container);
    this.els.tasks.editForm.hide();
    setTimeout($.proxy(this.bindEvents, this));

};


MassReassignment.prototype.bindEvents = function(){

    console.log('bind events');

        var reassignment1 = {
            container: '.taist-mass-reassignment',
            users: '.taist-mass-reassignment__user-select',
            submit: '.taist-mass-reassignment__user-button',
            projects: {
                item: '.taist-mass-reassignment__project',
                input: '.taist-mass-reassignment__project-title-checkbox'
            },
            tasks: {
                item: '.taist-mass-reassignment__task-item',
                input: '.taist-mass-reassignment__task-item-checkbox'
            }
        };

    // checkboxes
    // select
    // button


    var els = this.getNodesFromSelectors(this.settings.selectors.tasks.reassignment),
        activeProject = 'zzz';

    els.submit.click($.proxy(function(){

        els.projects.item.filter('.' + activeProject);

    }, this));














    var projects = {},
        tasks = {};

    projects.input = $(selectors.projects.input);
    projects.item = $(selectors.projects.item);
    tasks.input = $(selectors.tasks.input);
    tasks.item = $(selectors.tasks.item);

    projects.input.click($.proxy(function(i, element){

        var input = $(element),
            project = input.parents(projects.item);

        projects.input.not(input).attr({ disabled: true });
        

    }, this));

};



MassReassignment.prototype.reassign = function(taskId, userId){
    console.log('reassigned: ', taskId, userId);
};



MassReassignment.prototype.show = function(){

    console.log('show');

    this.els.tabs.items.removeClass(this.settings.classes.tabs.active);
    this.els.tabs.button.addClass(this.settings.classes.tabs.active);
    this.els.tasks.reassignment.container.show();
    this.els.tasks.editForm.hide();
};


MassReassignment.prototype.detach = function(){

    console.log('detach');

    var tabsConfig = this.settings.config.tabs,
        tabsClasses = this.settings.classes.tabs,
        tasksSelectors = this.settings.selectors.tasks,
        tabs = {},
        tasks = {};

    tabs.all = $(this.settings.selectors.tabs.items);
    tabs.reassignment = tabs.all.filter($.tmpl('[rel="#{rel}"]', tabsConfig));
    tabs.initial = tabs.all.not(tabs.reassignment);
    tabs.firstSelected = tabs.initial.filter($.tmpl('[rel="#{initialRel}"]', tabsConfig));

    tasks.container = $(tasksSelectors.reassignment.container);
    tasks.editForm = $(tasksSelectors.editForm);

    if ( !tabs.firstSelected.length ) {
        tabs.firstSelected = tabs.initial.filter('.' + tabsClasses.active);
        tabs.firstSelected.attr({ rel: tabsConfig.initialRel });
    }
    else {
        tabs.all.removeClass(tabsClasses.active);
        tabs.firstSelected.addClass(tabsClasses.active);
    }

    tabs.reassignment.remove();
    tasks.container.remove();
    tasks.editForm.show();
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
