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
                container: '#tasks'
            }
        },
        classes: {
            tabs: {
                active: 'act'
            },
            tasks: {
                wrapper: 'taist-mass-reassignment',
                ajaxContainer: 'taist-mass-reassignment__ajax-container'
            }
        },
        config: {
            tabs: {
                /* todo: resolve encoding problem */
                text: '\u041F\u0435\u0440\u0435\u043D\u0430\u0437\u043D\u0430\u0447\u0438\u0442\u044C \u0437\u0430\u0434\u0430\u0447\u0438',
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
                item: '<\a rel="#{rel}" href="/profile/#{hash}">#{text}<\/a>'
            },
            tasks: {



                project: decodeURIComponent(''),
                item: '%3Cli%20class%3D%22taist-mass-reassignment__task-item%22%3E%3Cspan%20class%3D%22taist-mass-reassignment__task-item-checkbox-wrapper%22%3E%3Cinput%20class%3D%22taist-mass-reassignment__task-item-checkbox%22%20type%3D%22checkbox%22%3E%3C%2Fspan%3E%3Ca%20class%3D%22taist-mass-reassignment__task-item-link%22%3E#{task}%3Cspan%20title%3D%22%D0%9F%D1%80%D0%B8%D0%BE%D1%80%D0%B8%D1%82%D0%B5%D1%82%3A%20#{priority}%22%20class%3D%22taist-mass-reassignment__task-priority%20taist-mass-reassignment__task-priority_value_#{priority}%22%3E#{priority}%3C%2Fspan%3E%3C%2Fa%3E%3C%2Fli%3E',


                wrapper: '<\div class="#{wrapper} task task1st"><\/div>',
                projects: '<div class=taist-mass-reassignment__user><span class=taist-mass-reassignment__user-text>\u041F\u0435\u0440\u0435\u043D\u0430\u0437\u043D\u0430\u0447\u0438\u0442\u044C \u043D\u0430 \u043F\u043E\u043B\u044C\u0437\u043E\u0432\u0430\u0442\u0435\u043B\u044F</span><select class=taist-mass-reassignment__user-select><option>\u0418\u0432\u0430\u043D \u041F\u0435\u0442\u0440\u043E\u0432<option>\u041F\u0435\u0442\u0440 \u0418\u0432\u0430\u043D\u043E\u0432</select></div><div class=taist-mass-reassignment__tasks><div class=taist-mass-reassignment__project><div class=taist-mass-reassignment__project-title><span class=taist-mass-reassignment__project-title-checkbox-wrapper><input class=taist-mass-reassignment__project-title-checkbox type=checkbox></span><a class=taist-mass-reassignment__project-title-link>Taist \u0438\u0437\u0431\u0430\u0432\u043B\u044F\u0435\u0442 \u043A\u043E\u043C\u0430\u043D\u0434\u044B b2b \u0432\u0435\u0431-\u0441\u0435\u0440\u0432\u0438\u0441\u043E\u0432</a></div><ul class=taist-mass-reassignment__task-list><li class=taist-mass-reassignment__task-item><span class=taist-mass-reassignment__task-item-checkbox-wrapper><input class=taist-mass-reassignment__task-item-checkbox type=checkbox></span><a class=taist-mass-reassignment__task-item-link>Taist \u0438\u0437\u0431\u0430\u0432\u043B\u044F\u0435\u0442 \u043A\u043E\u043C\u0430\u043D\u0434\u044B b2b \u0432\u0435\u0431-\u0441\u0435\u0440\u0432\u0438\u0441\u043E\u0432<span title=\"\u041F\u0440\u0438\u043E\u0440\u0438\u0442\u0435\u0442: 9\" class=\"taist-mass-reassignment__task-priority taist-mass-reassignment__task-priority_value_8\">8</span></a></li><li class=taist-mass-reassignment__task-item><span class=taist-mass-reassignment__task-item-checkbox-wrapper><input class=taist-mass-reassignment__task-item-checkbox type=checkbox></span><a class=taist-mass-reassignment__task-item-link>Taist \u0438\u0437\u0431\u0430\u0432\u043B\u044F\u0435\u0442 \u043A\u043E\u043C\u0430\u043D\u0434\u044B b2b \u0432\u0435\u0431-\u0441\u0435\u0440\u0432\u0438\u0441\u043E\u0432<span title=\"\u041F\u0440\u0438\u043E\u0440\u0438\u0442\u0435\u0442: 9\" class=\"taist-mass-reassignment__task-priority taist-mass-reassignment__task-priority_value_7\">7</span></a></li><li class=taist-mass-reassignment__task-item><span class=taist-mass-reassignment__task-item-checkbox-wrapper><input class=taist-mass-reassignment__task-item-checkbox type=checkbox></span><a class=taist-mass-reassignment__task-item-link>Taist \u0438\u0437\u0431\u0430\u0432\u043B\u044F\u0435\u0442 \u043A\u043E\u043C\u0430\u043D\u0434\u044B b2b \u0432\u0435\u0431-\u0441\u0435\u0440\u0432\u0438\u0441\u043E\u0432<span title=\"\u041F\u0440\u0438\u043E\u0440\u0438\u0442\u0435\u0442: 9\" class=\"taist-mass-reassignment__task-priority taist-mass-reassignment__task-priority_value_10\">10</span></a></li></ul></div><div class=taist-mass-reassignment__project><div class=taist-mass-reassignment__project-title><span class=taist-mass-reassignment__project-title-checkbox-wrapper><input class=taist-mass-reassignment__project-title-checkbox type=checkbox></span><a class=taist-mass-reassignment__project-title-link>Taist \u0438\u0437\u0431\u0430\u0432\u043B\u044F\u0435\u0442 \u043A\u043E\u043C\u0430\u043D\u0434\u044B b2b \u0432\u0435\u0431-\u0441\u0435\u0440\u0432\u0438\u0441\u043E\u0432</a></div><ul class=taist-mass-reassignment__task-list><li class=taist-mass-reassignment__task-item><span class=taist-mass-reassignment__task-item-checkbox-wrapper><input class=taist-mass-reassignment__task-item-checkbox type=checkbox></span><a class=taist-mass-reassignment__task-item-link>Taist \u0438\u0437\u0431\u0430\u0432\u043B\u044F\u0435\u0442 \u043A\u043E\u043C\u0430\u043D\u0434\u044B b2b \u0432\u0435\u0431-\u0441\u0435\u0440\u0432\u0438\u0441\u043E\u0432<span title=\"\u041F\u0440\u0438\u043E\u0440\u0438\u0442\u0435\u0442: 9\" class=\"taist-mass-reassignment__task-priority taist-mass-reassignment__task-priority_value_8\">8</span></a></li><li class=taist-mass-reassignment__task-item><span class=taist-mass-reassignment__task-item-checkbox-wrapper><input class=taist-mass-reassignment__task-item-checkbox type=checkbox></span><a class=taist-mass-reassignment__task-item-link>Taist \u0438\u0437\u0431\u0430\u0432\u043B\u044F\u0435\u0442 \u043A\u043E\u043C\u0430\u043D\u0434\u044B b2b \u0432\u0435\u0431-\u0441\u0435\u0440\u0432\u0438\u0441\u043E\u0432<span title=\"\u041F\u0440\u0438\u043E\u0440\u0438\u0442\u0435\u0442: 9\" class=\"taist-mass-reassignment__task-priority taist-mass-reassignment__task-priority_value_7\">7</span></a></li><li class=taist-mass-reassignment__task-item><span class=taist-mass-reassignment__task-item-checkbox-wrapper><input class=taist-mass-reassignment__task-item-checkbox type=checkbox></span><a class=taist-mass-reassignment__task-item-link>Taist \u0438\u0437\u0431\u0430\u0432\u043B\u044F\u0435\u0442 \u043A\u043E\u043C\u0430\u043D\u0434\u044B b2b \u0432\u0435\u0431-\u0441\u0435\u0440\u0432\u0438\u0441\u043E\u0432<span title=\"\u041F\u0440\u0438\u043E\u0440\u0438\u0442\u0435\u0442: 9\" class=\"taist-mass-reassignment__task-priority taist-mass-reassignment__task-priority_value_10\">10</span></a></li></ul></div></div>',
                projects111: '%3Cdiv%20class%3Dtaist-mass-reassignment__user%3E%3Cspan%20class%3Dtaist-mass-reassignment__user-text%3E%D0%9F%D0%B5%D1%80%D0%B5%D0%BD%D0%B0%D0%B7%D0%BD%D0%B0%D1%87%D0%B8%D1%82%D1%8C%20%D0%BD%D0%B0%20%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D0%BE%D0%B2%D0%B0%D1%82%D0%B5%D0%BB%D1%8F%3C%2Fspan%3E%3Cselect%20class%3Dtaist-mass-reassignment__user-select%3E%3Coption%3E%D0%98%D0%B2%D0%B0%D0%BD%20%D0%9F%D0%B5%D1%82%D1%80%D0%BE%D0%B2%3Coption%3E%D0%9F%D0%B5%D1%82%D1%80%20%D0%98%D0%B2%D0%B0%D0%BD%D0%BE%D0%B2%3C%2Fselect%3E%3C%2Fdiv%3E%3Cdiv%20class%3Dtaist-mass-reassignment__tasks%3E%3Cdiv%20class%3Dtaist-mass-reassignment__project%3E%3Cdiv%20class%3Dtaist-mass-reassignment__project-title%3E%3Cspan%20class%3Dtaist-mass-reassignment__project-title-checkbox-wrapper%3E%3Cinput%20class%3Dtaist-mass-reassignment__project-title-checkbox%20type%3Dcheckbox%3E%3C%2Fspan%3E%3Ca%20class%3Dtaist-mass-reassignment__project-title-link%3ETaist%20%D0%B8%D0%B7%D0%B1%D0%B0%D0%B2%D0%BB%D1%8F%D0%B5%D1%82%20%D0%BA%D0%BE%D0%BC%D0%B0%D0%BD%D0%B4%D1%8B%20b2b%20%D0%B2%D0%B5%D0%B1-%D1%81%D0%B5%D1%80%D0%B2%D0%B8%D1%81%D0%BE%D0%B2%3C%2Fa%3E%3C%2Fdiv%3E%3Cul%20class%3Dtaist-mass-reassignment__task-list%3E%3Cli%20class%3Dtaist-mass-reassignment__task-item%3E%3Cspan%20class%3Dtaist-mass-reassignment__task-item-checkbox-wrapper%3E%3Cinput%20class%3Dtaist-mass-reassignment__task-item-checkbox%20type%3Dcheckbox%3E%3C%2Fspan%3E%3Ca%20class%3Dtaist-mass-reassignment__task-item-link%3ETaist%20%D0%B8%D0%B7%D0%B1%D0%B0%D0%B2%D0%BB%D1%8F%D0%B5%D1%82%20%D0%BA%D0%BE%D0%BC%D0%B0%D0%BD%D0%B4%D1%8B%20b2b%20%D0%B2%D0%B5%D0%B1-%D1%81%D0%B5%D1%80%D0%B2%D0%B8%D1%81%D0%BE%D0%B2%3Cspan%20title%3D%22%D0%9F%D1%80%D0%B8%D0%BE%D1%80%D0%B8%D1%82%D0%B5%D1%82%3A%209%22%20class%3D%22taist-mass-reassignment__task-priority%20taist-mass-reassignment__task-priority_value_8%22%3E8%3C%2Fspan%3E%3C%2Fa%3E%3C%2Fli%3E%3Cli%20class%3Dtaist-mass-reassignment__task-item%3E%3Cspan%20class%3Dtaist-mass-reassignment__task-item-checkbox-wrapper%3E%3Cinput%20class%3Dtaist-mass-reassignment__task-item-checkbox%20type%3Dcheckbox%3E%3C%2Fspan%3E%3Ca%20class%3Dtaist-mass-reassignment__task-item-link%3ETaist%20%D0%B8%D0%B7%D0%B1%D0%B0%D0%B2%D0%BB%D1%8F%D0%B5%D1%82%20%D0%BA%D0%BE%D0%BC%D0%B0%D0%BD%D0%B4%D1%8B%20b2b%20%D0%B2%D0%B5%D0%B1-%D1%81%D0%B5%D1%80%D0%B2%D0%B8%D1%81%D0%BE%D0%B2%3Cspan%20title%3D%22%D0%9F%D1%80%D0%B8%D0%BE%D1%80%D0%B8%D1%82%D0%B5%D1%82%3A%209%22%20class%3D%22taist-mass-reassignment__task-priority%20taist-mass-reassignment__task-priority_value_7%22%3E7%3C%2Fspan%3E%3C%2Fa%3E%3C%2Fli%3E%3Cli%20class%3Dtaist-mass-reassignment__task-item%3E%3Cspan%20class%3Dtaist-mass-reassignment__task-item-checkbox-wrapper%3E%3Cinput%20class%3Dtaist-mass-reassignment__task-item-checkbox%20type%3Dcheckbox%3E%3C%2Fspan%3E%3Ca%20class%3Dtaist-mass-reassignment__task-item-link%3ETaist%20%D0%B8%D0%B7%D0%B1%D0%B0%D0%B2%D0%BB%D1%8F%D0%B5%D1%82%20%D0%BA%D0%BE%D0%BC%D0%B0%D0%BD%D0%B4%D1%8B%20b2b%20%D0%B2%D0%B5%D0%B1-%D1%81%D0%B5%D1%80%D0%B2%D0%B8%D1%81%D0%BE%D0%B2%3Cspan%20title%3D%22%D0%9F%D1%80%D0%B8%D0%BE%D1%80%D0%B8%D1%82%D0%B5%D1%82%3A%209%22%20class%3D%22taist-mass-reassignment__task-priority%20taist-mass-reassignment__task-priority_value_10%22%3E10%3C%2Fspan%3E%3C%2Fa%3E%3C%2Fli%3E%3C%2Ful%3E%3C%2Fdiv%3E%3Cdiv%20class%3Dtaist-mass-reassignment__project%3E%3Cdiv%20class%3Dtaist-mass-reassignment__project-title%3E%3Cspan%20class%3Dtaist-mass-reassignment__project-title-checkbox-wrapper%3E%3Cinput%20class%3Dtaist-mass-reassignment__project-title-checkbox%20type%3Dcheckbox%3E%3C%2Fspan%3E%3Ca%20class%3Dtaist-mass-reassignment__project-title-link%3ETaist%20%D0%B8%D0%B7%D0%B1%D0%B0%D0%B2%D0%BB%D1%8F%D0%B5%D1%82%20%D0%BA%D0%BE%D0%BC%D0%B0%D0%BD%D0%B4%D1%8B%20b2b%20%D0%B2%D0%B5%D0%B1-%D1%81%D0%B5%D1%80%D0%B2%D0%B8%D1%81%D0%BE%D0%B2%3C%2Fa%3E%3C%2Fdiv%3E%3Cul%20class%3Dtaist-mass-reassignment__task-list%3E%3Cli%20class%3Dtaist-mass-reassignment__task-item%3E%3Cspan%20class%3Dtaist-mass-reassignment__task-item-checkbox-wrapper%3E%3Cinput%20class%3Dtaist-mass-reassignment__task-item-checkbox%20type%3Dcheckbox%3E%3C%2Fspan%3E%3Ca%20class%3Dtaist-mass-reassignment__task-item-link%3ETaist%20%D0%B8%D0%B7%D0%B1%D0%B0%D0%B2%D0%BB%D1%8F%D0%B5%D1%82%20%D0%BA%D0%BE%D0%BC%D0%B0%D0%BD%D0%B4%D1%8B%20b2b%20%D0%B2%D0%B5%D0%B1-%D1%81%D0%B5%D1%80%D0%B2%D0%B8%D1%81%D0%BE%D0%B2%3Cspan%20title%3D%22%D0%9F%D1%80%D0%B8%D0%BE%D1%80%D0%B8%D1%82%D0%B5%D1%82%3A%209%22%20class%3D%22taist-mass-reassignment__task-priority%20taist-mass-reassignment__task-priority_value_8%22%3E8%3C%2Fspan%3E%3C%2Fa%3E%3C%2Fli%3E%3Cli%20class%3Dtaist-mass-reassignment__task-item%3E%3Cspan%20class%3Dtaist-mass-reassignment__task-item-checkbox-wrapper%3E%3Cinput%20class%3Dtaist-mass-reassignment__task-item-checkbox%20type%3Dcheckbox%3E%3C%2Fspan%3E%3Ca%20class%3Dtaist-mass-reassignment__task-item-link%3ETaist%20%D0%B8%D0%B7%D0%B1%D0%B0%D0%B2%D0%BB%D1%8F%D0%B5%D1%82%20%D0%BA%D0%BE%D0%BC%D0%B0%D0%BD%D0%B4%D1%8B%20b2b%20%D0%B2%D0%B5%D0%B1-%D1%81%D0%B5%D1%80%D0%B2%D0%B8%D1%81%D0%BE%D0%B2%3Cspan%20title%3D%22%D0%9F%D1%80%D0%B8%D0%BE%D1%80%D0%B8%D1%82%D0%B5%D1%82%3A%209%22%20class%3D%22taist-mass-reassignment__task-priority%20taist-mass-reassignment__task-priority_value_7%22%3E7%3C%2Fspan%3E%3C%2Fa%3E%3C%2Fli%3E%3Cli%20class%3Dtaist-mass-reassignment__task-item%3E%3Cspan%20class%3Dtaist-mass-reassignment__task-item-checkbox-wrapper%3E%3Cinput%20class%3Dtaist-mass-reassignment__task-item-checkbox%20type%3Dcheckbox%3E%3C%2Fspan%3E%3Ca%20class%3Dtaist-mass-reassignment__task-item-link%3ETaist%20%D0%B8%D0%B7%D0%B1%D0%B0%D0%B2%D0%BB%D1%8F%D0%B5%D1%82%20%D0%BA%D0%BE%D0%BC%D0%B0%D0%BD%D0%B4%D1%8B%20b2b%20%D0%B2%D0%B5%D0%B1-%D1%81%D0%B5%D1%80%D0%B2%D0%B8%D1%81%D0%BE%D0%B2%3Cspan%20title%3D%22%D0%9F%D1%80%D0%B8%D0%BE%D1%80%D0%B8%D1%82%D0%B5%D1%82%3A%209%22%20class%3D%22taist-mass-reassignment__task-priority%20taist-mass-reassignment__task-priority_value_10%22%3E10%3C%2Fspan%3E%3C%2Fa%3E%3C%2Fli%3E%3C%2Ful%3E%3C%2Fdiv%3E%3C%2Fdiv%3E',
                ajaxContainer: '<\div class="#{ajaxContainer} taist-mass-reassignment_hidden"><\/div>'
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
                project.href = name.attr('href');
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
        .prependTo(this.els.tasks.container)
        .load(this.settings.config.tasks.url, $.proxy(function(){
            callback ({
                projects: getProjects(this.els.tasks.ajaxContainer),
                users: getUsers(this.els.tasks.ajaxContainer)
            });
        }, this));
};


MassReassignment.prototype.render = function(data){

    console.log('>>> render:', data);

    var taskClasses = this.settings.classes.tasks,
        taskTemplates = this.settings.templates.tasks;


//    data.projects.each(function(i, project){
//        project.tasks.each(function(j, task){
//
//        });
//    });



    // this.els.tasks.wrapper = $( $.tmpl(taskTemplates.wrapper, taskClasses.wrapper) ); todo: fix
    this.els.tasks.wrapper = $( $.tmpl(taskTemplates.wrapper, { wrapper: 'taist-mass-reassignment' }) );
    

    this.els.tasks.wrapper
        .appendTo(this.els.tasks.container)
        //.append(taskTemplates.projects);
        .append(decodeURIComponent(taskTemplates.projects111));
        //.append('11111' + JSON.stringify(data));

    this.els.tasks.editForm.hide();

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
