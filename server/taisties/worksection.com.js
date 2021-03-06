if ( !window.console || !window.console.log ) {
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
                counter: '#dropMT',
                reassignment: {
                    wrapper: '.taist-mass-reassignment',
                    users: '.taist-mass-reassignment__user-select',
                    notify: '.taist-mass-reassignment__user-notification-checkbox',
                    submit: '.taist-mass-reassignment__user-button',
                    error: '.taist-mass-reassignment__error-tooltip',
                    errorClose: '.taist-mass-reassignment__error-tooltip-close',
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
                projectActive: 'taist-mass-reassignment__project_active'
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
                noTasksMessage: decodeURIComponent('%D0%9D%D0%B5%D1%82%20%D0%B7%D0%B0%D0%B4%D0%B0%D1%87'),
                ajaxTasks: {
                    url: '/ajax/?action=my_tasks',
                    selectors: {
                        projects: '.indrop > div',
                        projectName: '.proj',
                        tasks: '.list > div',
                        taskName: '> a',
                        taskPriority: '.priorb',
                        users: 'select[name="seluser"] option',
                        currentUser: '.also a:first'
                    }
                },
                iFrameReassignment: {
                    url: '/project/#{projectId}/#{taskId}/?action=set_user_to',
                    windowName: 'taist-iframe-reassignment-#{projectId}-#{taskId}',
                    selectors: {
                        form: 'form',
                        user: 'select[name="id_user_to"]',
                        mail: 'input[name="is_mail"]',
                        submit: 'input[name="set_user_to"]'
                    }
                }
            }
        },
        templates: {
            tabs: {
                link: decodeURIComponent('%3Ca%20rel%3D%22%23%7Brel%7D%22%20href%3D%22%2Fprofile%2F%23%7Bhash%7D%22%3E%D0%9F%D0%B5%D1%80%D0%B5%D0%BD%D0%B0%D0%B7%D0%BD%D0%B0%D1%87%D0%B8%D1%82%D1%8C%20%D0%B7%D0%B0%D0%B4%D0%B0%D1%87%D0%B8%3C%2Fa%3E')
            },
            tasks: {
                wrapper: decodeURIComponent('%3Cdiv%20class%3Dtaist-mass-reassignment%3E%3C%2Fdiv%3E'),
                container: decodeURIComponent('%3Cdiv%20class%3Dtaist-mass-reassignment__user%3E%3Cspan%20class%3Dtaist-mass-reassignment__user-text%3E%D0%9F%D0%B5%D1%80%D0%B5%D0%BD%D0%B0%D0%B7%D0%BD%D0%B0%D1%87%D0%B8%D1%82%D1%8C%20%D0%B7%D0%B0%D0%B4%D0%B0%D1%87%D0%B8%20%D0%BD%D0%B0%3Cspan%20class%3Dtaist-mass-reassignment__user-newline%3E%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D0%BE%D0%B2%D0%B0%D1%82%D0%B5%D0%BB%D1%8F%3C%2Fspan%3E%3C%2Fspan%3E%3Cselect%20class%3Dtaist-mass-reassignment__user-select%3E%23%7Busers%7D%3C%2Fselect%3E%3Clabel%20class%3Dtaist-mass-reassignment__user-notification%3E%3Cspan%20class%3Dtaist-mass-reassignment__user-notification-checkbox-wrapper%3E%3Cinput%20class%3Dtaist-mass-reassignment__user-notification-checkbox%20type%3Dcheckbox%20checked%3E%3C%2Fspan%3E%3Cspan%20class%3Dtaist-mass-reassignment__user-notification-text%20title%3D%22%D0%9E%D1%82%D0%BF%D1%80%D0%B0%D0%B2%D0%B8%D1%82%D1%8C%20%D1%83%D1%87%D0%B0%D1%81%D1%82%D0%BD%D0%B8%D0%BA%D0%B0%D0%BC%20e-mail%20%D1%83%D0%B2%D0%B5%D0%B4%D0%BE%D0%BC%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5%20%D0%BE%20%D0%B2%D0%BD%D0%B5%D1%81%D0%B5%D0%BD%D0%BD%D1%8B%D1%85%20%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D1%8F%D1%85%22%3E%D0%9E%D0%BF%D0%BE%D0%B2%D0%B5%D1%81%D1%82%D0%B8%D1%82%D1%8C%20%D0%BF%D0%BE%20e-mail%3C%2Fspan%3E%3C%2Flabel%3E%3Cbutton%20class%3Dtaist-mass-reassignment__user-button%3E%D0%93%D0%BE%D1%82%D0%BE%D0%B2%D0%BE%3C%2Fbutton%3E%3C%2Fdiv%3E%3Cdiv%20class%3Dtaist-mass-reassignment__tasks%3E%23%7Bprojects%7D%3C%2Fdiv%3E'),
                user: decodeURIComponent('%3Coption%20value%3D%22%23%7BuserId%7D%22%3E%23%7BuserName%7D%3C%2Foption%3E'),
                project: decodeURIComponent('%3Cdiv%20class%3Dtaist-mass-reassignment__project%20data-id%3D%22%23%7BprojectId%7D%22%3E%3Cdiv%20class%3Dtaist-mass-reassignment__project-title%3E%3Cspan%20class%3Dtaist-mass-reassignment__project-title-checkbox-wrapper%3E%3Cinput%20class%3Dtaist-mass-reassignment__project-title-checkbox%20type%3Dcheckbox%3E%3C%2Fspan%3E%3Ca%20href%3D%22%2Fproject%2F%23%7BprojectId%7D%2F%22%20class%3Dtaist-mass-reassignment__project-title-link%3E%23%7BprojectName%7D%3C%2Fa%3E%3C%2Fdiv%3E%3Cul%20class%3Dtaist-mass-reassignment__task-list%3E%23%7Btasks%7D%3C%2Ful%3E%3C%2Fdiv%3E'),
                task: decodeURIComponent('%3Cli%20class%3Dtaist-mass-reassignment__task-item%20data-id%3D%22%23%7BtaskId%7D%22%3E%3Cspan%20class%3Dtaist-mass-reassignment__task-item-checkbox-wrapper%3E%3Cinput%20class%3Dtaist-mass-reassignment__task-item-checkbox%20type%3Dcheckbox%3E%3C%2Fspan%3E%3Ca%20href%3D%22%2Fproject%2F%23%7BprojectId%7D%2F%23%7BtaskId%7D%2F%22%20class%3Dtaist-mass-reassignment__task-item-link%3E%23%7BtaskName%7D%3Cspan%20title%3D%22%D0%9F%D1%80%D0%B8%D0%BE%D1%80%D0%B8%D1%82%D0%B5%D1%82%3A%20%23%7BtaskPriority%7D%22%20class%3D%22taist-mass-reassignment__task-priority%20taist-mass-reassignment__task-priority_value_%23%7BtaskPriority%7D%22%3E%23%7BtaskPriority%7D%3C%2Fspan%3E%3C%2Fa%3E%3C%2Fli%3E'),
                ajaxTasks: decodeURIComponent('%3Cdiv%20class%3D%22taist-mass-reassignment__ajax-tasks%20taist-mass-reassignment_hidden%22%3E%3C%2Fdiv%3E'),
                iFrameReassignment: decodeURIComponent('%3Ciframe%20class%3D%22taist-mass-reassignment__iframe-reassignment%20taist-mass-reassignment_hidden%22%20name%3D%22%23%7BwindowName%7D%22%20src%3D%22%23%7Burl%7D%22%3E%3C%2Fiframe%3E'),
                error: decodeURIComponent('%3Cdiv%20class%3Dtaist-mass-reassignment__error-tooltip%3E%3Ci%20class%3Dtaist-mass-reassignment__error-tooltip-close%3EX%3C%2Fi%3E%D0%9D%D0%B5%D0%BB%D1%8C%D0%B7%D1%8F%20%D0%BD%D0%B0%D0%B7%D0%BD%D0%B0%D1%87%D0%B8%D1%82%D1%8C%20%D1%8D%D1%82%D1%83%20%D0%B7%D0%B0%D0%B4%D0%B0%D1%87%D1%83%20%D0%BD%D0%B0%20%D0%B4%D0%B0%D0%BD%D0%BD%D0%BE%D0%B3%D0%BE%20%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D0%BE%D0%B2%D0%B0%D1%82%D0%B5%D0%BB%D1%8F.%3C%2Fdiv%3E')
            }
        }
    };
};


MassReassignment.prototype.init = function(options){

    $.extend({
        proxy: function(func, context){
            return function(){
                func.apply(context, arguments);
            };
        },
        tmpl: Taist.utils.tmpl
    });

    console.log('Taist Mass reassignment: init');

    this.detach();


    // other_user
    // own_profile

    if ( options.page === 'other_user' ) {
        this.els.tabs.container = $();
    }



    this.els = this.getNodesFromSelectors(this.settings.selectors);
    this.els.tabs.button = $($.tmpl(this.settings.templates.tabs.link, this.settings.config.tabs));
    this.els.tabs.container.append(this.els.tabs.button);

    this.els.tasks.reassignment.wrapper = $($.tmpl(this.settings.templates.tasks.wrapper));
    this.els.tasks.reassignment.wrapper.appendTo(this.els.tasks.container).hide();

    this.getData($.proxy(this.render, this));

    this.els.tabs.button
        .unbind('click')
        .bind('click', $.proxy(this.show, this));

    if ( location.hash === this.settings.config.tabs.hash ) {
        this.show();
    }
};


MassReassignment.prototype.show = function(){
    console.log('Taist Mass reassignment: show');
    this.els.tabs.items.removeClass(this.settings.classes.tabs.active);
    this.els.tabs.button.addClass(this.settings.classes.tabs.active);
    this.els.tasks.reassignment.wrapper.show();
    this.els.tasks.editForm.hide();
};


MassReassignment.prototype.detach = function(){

    console.log('Taist Mass reassignment: detach');

    var tabsConfig = this.settings.config.tabs,
        tabsClasses = this.settings.classes.tabs,
        tasksSelectors = this.settings.selectors.tasks,
        tabs = {},
        tasks = {};

    tabs.all = $(this.settings.selectors.tabs.items);
    tabs.reassignment = tabs.all.filter($.tmpl('[rel="#{rel}"]', tabsConfig));
    tabs.initial = tabs.all.not(tabs.reassignment);
    tabs.firstSelected = tabs.initial.filter($.tmpl('[rel="#{initialRel}"]', tabsConfig));

    tasks.container = $(tasksSelectors.reassignment.wrapper);
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


MassReassignment.prototype.renderTabs = function(){


    this.els.tabs.button = $($.tmpl(this.settings.templates.tabs.link, this.settings.config.tabs));
    this.els.tabs.container.append(this.els.tabs.button);

    this.els.tasks.reassignment.wrapper = $($.tmpl(this.settings.templates.tasks.wrapper));
    this.els.tasks.reassignment.wrapper.appendTo(this.els.tasks.container).hide();



};


MassReassignment.prototype.render = function(data){

    var taskTemplates = this.settings.templates.tasks,
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
        projects: projects.length
            ? projects.join('\n')
            : this.settings.config.tasks.noTasksMessage
    });

    this.els.tasks.reassignment.wrapper.append(container);
    setTimeout($.proxy(this.bindEvents, this));
};


MassReassignment.prototype.bindEvents = function(){

    this.els.tasks.reassignment = this.getNodesFromSelectors(this.settings.selectors.tasks.reassignment);
    this.toggleUserBarState({ disabled: true });

    this.els.tasks.reassignment.projects.input.change($.proxy(function(event){
        var checkbox = $(event.currentTarget),
            checked = !!checkbox.filter(':checked').length,
            project = checkbox.parents(this.settings.selectors.tasks.reassignment.projects.item),
            projectTaskCheckboxes = project.find(this.settings.selectors.tasks.reassignment.tasks.input);
        projectTaskCheckboxes.attr({ checked: checked });
        this.highlightProject(checkbox);
    }, this));

    this.els.tasks.reassignment.tasks.input.change($.proxy(function(event){
        var checkbox = $(event.currentTarget),
            project = checkbox.parents(this.settings.selectors.tasks.reassignment.projects.item),
            projectCheckbox = project.find(this.settings.selectors.tasks.reassignment.projects.input),
            projectTaskCheckboxes = project.find(this.settings.selectors.tasks.reassignment.tasks.input),
            allChecked = projectTaskCheckboxes.length === projectTaskCheckboxes.filter(':checked').length;
        projectCheckbox.attr({ checked: allChecked });
        this.highlightProject(checkbox);
    }, this));

    this.els.tasks.reassignment.submit.click($.proxy(function(){
        var tasks = this.getSelectedTasks(),
            user = this.getSelectedUser(),
            notify = this.getSelectedNotificationPolicy();
        this.reassign(tasks, user, notify);
    }, this));

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

    var selectors = this.settings.config.tasks.ajaxTasks.selectors,
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

            var users = [],
                currentUser = +container
                    .find(selectors.currentUser)
                    .attr('href')
                    .split('sel_user=')[1];

            container.find(selectors.users).each(function(i,e){

                var user = {},
                    el = $(e);

                user.name = el.html();
                user.id = +el.attr('value');
                user.id !== currentUser && users.push(user);
            });

            return users;

        };

    this.els.tasks.ajaxTasks = $( $.tmpl(this.settings.templates.tasks.ajaxTasks) );
    this.els.tasks.ajaxTasks
        .appendTo(this.els.tasks.container)
        .load(this.settings.config.tasks.ajaxTasks.url, $.proxy(function(){
            callback ({
                projects: getProjects(this.els.tasks.ajaxTasks),
                users: getUsers(this.els.tasks.ajaxTasks)
            });
        }, this));
};


MassReassignment.prototype.highlightProject = function(element){

    element = element instanceof $
        ? element
        : $(element);

    var projectActiveClass = this.settings.classes.tasks.projectActive,
        projectsAll = this.els.tasks.reassignment.projects.item,
        projectActive = element.parents(this.settings.selectors.tasks.reassignment.projects.item),
        checkboxesAllProjects = projectsAll.find('input[type=checkbox]'),
        checkboxesActiveProject = projectActive.find('input[type=checkbox]'),
        checkboxesActiveProjectChecked = !!checkboxesActiveProject.filter(':checked').length;

    if ( checkboxesActiveProjectChecked ) {
        projectsAll.removeClass(projectActiveClass);
        checkboxesAllProjects.attr({ disabled: true });
        projectActive.addClass(projectActiveClass);
        checkboxesActiveProject.attr({ disabled: false });
        this.toggleUserBarState({ disabled: false });
    }
    else {
        projectsAll.removeClass(projectActiveClass);
        checkboxesAllProjects.attr({ disabled: false });
        this.toggleUserBarState({ disabled: true });
    }
};


MassReassignment.prototype.toggleUserBarState = function(options){
    var els = this.els.tasks.reassignment;
    els.users.attr(options);
    els.notify.attr(options);
    els.submit.attr(options);
};


MassReassignment.prototype.getSelectedUser = function(){

    var id = +this.els.tasks.reassignment.users.val(),
        name = this.els.tasks.reassignment.users.find('[value="' + id + '"]').html();
    return {
        id: id,
        name: name
    };
};


MassReassignment.prototype.getSelectedTasks = function(){

    var taskIds = [],
        project = this.els.tasks.reassignment.projects.item
            .filter('.' + this.settings.classes.tasks.projectActive),
        projectId = +project.attr('data-id');

    project
        .find(this.settings.selectors.tasks.reassignment.tasks.input)
        .filter(':checked')
        .each($.proxy(function(i, element){
            var taskId = $(element)
                .parents(this.settings.selectors.tasks.reassignment.tasks.item)
                .attr('data-id');
            taskIds.push(+taskId);
        }, this));

    return {
        projectId: projectId,
        taskIds: taskIds
    };
};


MassReassignment.prototype.getSelectedNotificationPolicy = function(){
    return this.els.tasks.reassignment.notify.filter(':checked').length;
};


MassReassignment.prototype.createReassignmentFrame = function(params, callback){

    var windowName = $.tmpl(this.settings.config.tasks.iFrameReassignment.windowName, params),
        frameHtml = $.tmpl(this.settings.templates.tasks.iFrameReassignment, {
            windowName: windowName,
            url: $.tmpl(this.settings.config.tasks.iFrameReassignment.url, params)
        });

    this.els.tasks.container.append(frameHtml);
    $(window[windowName]).load(callback);
};


MassReassignment.prototype.reassign = function(tasks, user, notify){

    console.log('Taist Mass reassignment: tasks reassigned: ', tasks, user);

    $.each(tasks.taskIds, $.proxy(function(i, taskId){

        var selectors = this.settings.config.tasks.iFrameReassignment.selectors,
            frame = {
                name: $.tmpl(this.settings.config.tasks.iFrameReassignment.windowName, {
                    projectId:  tasks.projectId,
                    taskId:     taskId
                })
            };

        $( $.tmpl('[name="#{name}"]', {
            name: frame.name
        })).remove();

        this.createReassignmentFrame({ projectId: tasks.projectId, taskId: taskId }, $.proxy(function(){

            frame.el = $($.tmpl('[name="#{name}"]', {
                name: frame.name
            }));

            frame.document = window[frame.name].document;
            frame.user = $(selectors.user, frame.document);
            frame.mail = $(selectors.mail, frame.document);
            frame.submit = $(selectors.submit, frame.document);

            frame.mail.attr({ checked: notify });
            frame.user.val(user.id);

            if ( !frame.user.length || !frame.submit.length ) {
                this.generateError();
                return;
            }

            frame.submit.trigger('click');

            setTimeout($.proxy(function(){
                this.removeTasksFromList(tasks.projectId, taskId);
            }, this), 1000);

        }, this));
    }, this));
};


MassReassignment.prototype.removeTasksFromList = function(projectId, taskId){

    var task = this.els.tasks.reassignment.tasks.item.filter($.tmpl('[data-id="#{id}"]', { id: taskId })),
        project = this.els.tasks.reassignment.projects.item.filter($.tmpl('[data-id="#{id}"]', { id: projectId })),
        counter = this.els.tasks.counter,
        counterText,
        count;

    task.remove();

    count = $(this.settings.selectors.tasks.reassignment.tasks.item).length;
    counterText = counter.html().replace(/\([0-9]+\)/, count ? $.tmpl('(#{c})', { c: count }) : '');
    counter.html(counterText);

    project.removeClass(this.settings.classes.tasks.projectActive);
    $(this.settings.selectors.tasks.reassignment.projects.input).attr({ disabled: false });
    $(this.settings.selectors.tasks.reassignment.tasks.input).attr({ disabled: false });

    this.toggleUserBarState({ disabled: true });

    if ( !count ) {
        project.parent().append(this.settings.config.tasks.noTasksMessage);
    }

    if ( !project.find(this.settings.selectors.tasks.reassignment.tasks.item).length ) {
        project.remove();
    }
};


MassReassignment.prototype.generateError = function(){

    var tooltip = $(this.settings.templates.tasks.error),
        close;

    tooltip
        .insertAfter(this.els.tasks.reassignment.submit)
        .hide().fadeIn(400);

    close = tooltip.find(this.settings.selectors.tasks.reassignment.errorClose);

    close.click(function(){
        tooltip.fadeOut(200, function(){
            tooltip.remove();
        });
    });

    setTimeout(function(){
        tooltip.fadeOut(400, function(){
            tooltip.remove();
        });
    }, 10000);

};


Taist.MassReassignment = new MassReassignment();




/*
 * TODO: MOVE TO DOWNLOADER.JS
 */

Taist.Tests = {
    pages: {
        massReassignmentOwnProfile: {
            path: /^\/(?:profile|profile_tune)(?:\/)?$/,
            method: function(){
                Taist.MassReassignment.init({
                    page: 'own_profile'
                });
            },
            selectors: {
                titleTabs: '#title_tabs'
            }
        },
        massReassignmentOtherUser: {
            path: /^\/users\/[0-9]+\/edit(?:\/)?$/,
            method: function(){
                Taist.MassReassignment.init({
                    page: 'other_user'
                });
            },
            selectors: {
                titleContainer: '#title'
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
                    this.pages[page].method();
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
