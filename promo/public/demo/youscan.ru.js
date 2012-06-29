if ( !console || !console.log ) {
    console = { log: function(){} };
}


console.log('start');

var getState = function(){
    return localStorage.getItem('taist_taistieState') === 'active';
};

var MentionTags = {
    els: {
        mention: {
            container: $('.mention_item')
        },
        popup: {
            container: $('.mentionTagsList')
        }
    },
    selectors: {
        mention: {
            tagContainer: '[id^="mentionIdForTags"]',
            middleBlock: '.mention_middle_block',
            tags: '.textTag',
            remove: '.tagRemoveBtn',
            addButton: '.mention_addtags, .mention_edittags:visible'
        }
    },
    tags: {},
    totalTagCount: 20,
    maxMentionTagCount: 5,

    init: function(){

        this.els.popup.tags = this.els.popup.container.find('.textTag');
        this.els.popup.input = this.els.popup.container.find('.tagsInputReset');
        this.els.popup.addButton = this.els.popup.container.find('.addTagButton');
        this.els.popup.save = this.els.popup.container.find('.activePanelButton');

        this.els.popup.tags.each($.proxy(function(i, element){
            var el = $(element),
                id = el.parent().find('input[type=checkbox]').val();
            this.tags[id] = el.attr('title').toLowerCase();
        }, this));

        this.renderTags();

    },
    toggleTag: function(mention, element){

        element.bind('click', $.proxy(function(event){

            var el = $(event.currentTarget),
                id = el.attr('data-id'),
                selected = el.hasClass(mention.classes.selected),
                checkBoxes = this.els.popup.tags.parent().find('input[type=checkbox]'),
                checkbox = checkBoxes.filter('[value=' + id + ']');

            if ( mention.taist.list.find('.' + mention.classes.tag + '.' + mention.classes.selected).length >= this.maxMentionTagCount && !selected ) {
                alert('Достигнут лимит выбранных тэгов для одного упоминания.');
                return false;
            }

            mention.addButton.trigger('click');

            mention.taist.list
                .find('.' + mention.classes.tag + '.' + mention.classes.selected)
                .each(function(i, e){
                    checkBoxes.filter('[value=' + $(e).attr('data-id') + ']').attr({ checked: true });
                });

            if ( selected ) {
                checkbox.attr({ checked: false });
                el.removeClass(mention.classes.selected);
            }
            else {
                checkbox.attr({ checked: true });
                el.addClass(mention.classes.selected);
            }

            setTimeout($.proxy(function(){
                this.setTagBlockHeight(mention);
            }, this), 0);

            try {
                this.els.popup.save.trigger('click');
            }
            finally {
                this.checkErrors();
            }

        }, this));

    },
    addTagByEnterPress: function(mention, element){

        element.bind('keypress', $.proxy(function(event){
            var el = $(event.currentTarget),
                value = el.val();
            if ( event.which === 13 && value ) {
                this.addTag(mention, value);
                el.val('').focus();
            }
        }, this));
    },
    addTagByButtonPress: function(mention, element){

        element.bind('click', $.proxy(function(event){
            var el = $(event.currentTarget),
                input = el.siblings(mention.taist.input),
                value = input.val();
            if ( value ) {
                this.addTag(mention, value);
                input.val('').focus();
            }
        }, this));
    },
    addTag: function(mention, value){

        if ( !value ) {
            return false;
        }

        if ( this.els.popup.tags.length >= this.totalTagCount ) {
            alert('Достигнут лимит по количеству тегов для темы.');
            return false;
        }

        if ( mention.taist.list.find('.' + mention.classes.tag + '.' + mention.classes.selected).length >= this.maxMentionTagCount ) {
            alert('Достигнут лимит выбранных тэгов для одного упоминания.');
            return false;
        }

        var checkBoxes = this.els.popup.tags.parent().find('input[type=checkbox]'),
            tagCount = mention.tags.length,
            popUpTagCheckbox,
            newTag,
            newTagReady,
            newTagId = 0;

        mention.addButton.trigger('click');
        this.els.popup.input.val(value);
        this.els.popup.addButton.trigger('click');

        this.els.popup.tags = this.els.popup.container.find(this.selectors.mention.tags);
        this.els.popup.tags.each(function(i, element){
            var el = $(element);
            if ( el.html() === value ) {
                popUpTagCheckbox = el.parent().find('input[type=checkbox]');
            }
        });

        popUpTagCheckbox.attr({ checked: true });

        mention.taist.list
            .find('.' + mention.classes.tag + '.' + mention.classes.selected)
            .each(function(i, e){
                checkBoxes.filter('[value=' + $(e).attr('data-id') + ']').attr({ checked: true });
            });

        newTag = $('<div class="'+mention.classes.tag+ ' ' + mention.classes.selected +'" data-id="'+ newTagId +'">'+value+'</div>');

        mention.taist.list.append(newTag);

        mention.taist.list
            .find('.' + mention.classes.tag)
            .sort(function(a,b){ return $(a).html() < $(b).html() ? -1 : 1; })
            .appendTo( mention.taist.list.empty() );

        newTag.addClass(mention.classes.highlighted);

        setTimeout($.proxy(function(){
            this.toggleTag(mention, mention.taist.list.find('.' + mention.classes.tag));
            this.setTagBlockHeight(mention);
        }, this), 0);

        setTimeout(function(){
            newTag.removeClass(mention.classes.highlighted);
        }, 1000);

        try {
            this.els.popup.save.trigger('click');
        }
        finally {
            this.checkErrors();
        }

        console.log('add new tag:',
            +new Date(),
            new Date().toString(),
            value
        );

        newTagReady = setInterval($.proxy(function(){

            console.log('check new tag:',
                +new Date(),
                new Date().toString(),
                mention.el.find(this.selectors.mention.tags).length,
                mention.el.find(this.selectors.mention.tags)
            );

            if ( mention.el.find(this.selectors.mention.tags).length > tagCount ) {

                clearInterval(newTagReady);
                mention.tags = mention.el.find(this.selectors.mention.tags);

                newTagId = mention.tags
                    .parent()
                    .filter(':contains("' + value + '")')
                    .attr('id');

                mention.taist.list
                    .find('.' + mention.classes.tag)
                    .filter(':contains("' + value + '")')
                    .attr({ 'data-id': newTagId });

                console.log('new tag ready:',
                    +new Date(),
                    new Date().toString(),
                    newTagId,
                    mention.taist.list.find('.' + mention.classes.tag).filter('[data-id="' + newTagId + '"]'),
                    mention.tags.parent().filter(':contains("' + value + '")')
                );
            }

        }, this), 1000);
    },
    setTagBlockHeight: function(mention){
        var height = mention.taist.list.height();
        mention.taist.container.css({ marginTop: ( 83 + height ) * -1 + 'px' });
        mention.middleBlock.css({ paddingBottom: 40 + height + 'px' });
    },
    checkErrors: function(){
        setTimeout($.proxy(function(){
            if ( this.els.popup.container.filter(':visible').length ) {
                alert('Произошла ошибка. Пожалуйста, перезагрузите страницу.');
            }
        }, this), 1000);
    },
    renderTags: function(){

        this.els.mention.container.each($.proxy(function(i, element){

            var mention = {
                    el: $(element),
                    classes: {
                        tag: 'mention_simple_tags_item',
                        text: 'mention_simple_tags_text',
                        remove: 'mention_simple_tags_remove',
                        selected: 'tag_selected',
                        highlighted: 'tag_highlighted'
                    },
                    taist: {
                        container:  $('<div class="mention_simple_tags"><div class="mention_simple_tags_title">Тэги:</div></div>'),
                        list:       $('<div class="mention_simple_tags_list"></div>'),
                        addBlock:  	$('<div class="mention_simple_tags_add"></div>'),
                        input:      $('<input type="text" class="mention_simple_tags_input" placeholder="Новый тэг">'),
                        button:     $('<button class="mention_simple_tags_button">Добавить</button>')
                    }
                },
                mentionTags = [],
                resizeTimer = false,
                cssReady;

                mention.tagContainer = mention.el.find(this.selectors.mention.tagContainer);
                mention.middleBlock = mention.el.find(this.selectors.mention.middleBlock);
                mention.tags = mention.el.find(this.selectors.mention.tags);
                mention.addButton = mention.el.find(this.selectors.mention.addButton);

            for ( var tagId in this.tags ) {
                var tagData = {
                    id: tagId,
                    text: this.tags[tagId],
                    selected: mention.tags.parent().filter('[id=' + tagId + ']').length
                };
                mentionTags.push(tagData);
            }

            mentionTags.sort(function(a, b){
                return a.text < b.text ? -1 : 1;
            });

            $.each(mentionTags, function(i, tag){
                var el = $('<div></div>')
                    .addClass(mention.classes.tag)
                    .attr({ 'data-id': tag.id })
                    .html( tag.text );

                tag.selected && el.addClass(mention.classes.selected);
                mention.taist.list.append(el);
            });

            mention.tagContainer.hide();

            mention.taist.addBlock
                .append(mention.taist.input)
                .append(mention.taist.button);

            mention.taist.container
                .append(mention.taist.list)
                .append(mention.taist.addBlock);

            mention.el
                .after(mention.taist.container);

            cssReady = setInterval($.proxy(function(){
                if ( mention.taist.container.eq(0).css('overflow') === 'hidden' ) {
                    clearInterval(cssReady);
                    this.setTagBlockHeight(mention);
                    this.toggleTag(mention, mention.taist.list.find('.' + mention.classes.tag));
                    this.addTagByEnterPress(mention, mention.taist.input);
                    this.addTagByButtonPress(mention, mention.taist.button);
                }
            }, this), 100);


            $(window).resize($.proxy(function(event){
                if ( resizeTimer ) return false;
                resizeTimer = true;
                setTimeout($.proxy(function(){
                    resizeTimer = false;
                    this.setTagBlockHeight(mention);
                }, this), 100);
            }, this));

            if ( !( 'placeholder' in mention.taist.input[0] ) ) {
                mention.taist.input
                    .val( mention.taist.input.attr('placeholder') )
                    .one('focus', function(){
                        $(this).val('');
                    });
            }
        }, this));
    }
};



var Settings = {
    els: {},
    selectors: {
        container:  '.cornerBottomR',
        menu:       '.links_right'
    },
    classes: {
        active:     'link_active',
        inactive:   'violet_right',
        block:      'taist__settings-block',
        label:      'taist__settings_label',
        checkbox:   'taist__settings-checkbox'
    },
    config: {
        hash:       '#interface',
        tabText:    'Интерфейс',
        label:      'Включить улучшенные тэги упоминаний'
    },
    init: function(){

        this.els.container =    $(this.selectors.container);
        this.els.menu =         $(this.selectors.menu);
        this.els.header =       this.els.container.find('h2');

        this.els.tabLink =  $('<a></a>').addClass(this.classes.inactive).html(this.config.tabText);
        this.els.tab =      $('<li></li>');
        this.els.block =    $('<div></div>').addClass(this.classes.block);
        this.els.label =    $('<label></label>').addClass(this.classes.label);
        this.els.checkbox = $('<input type="checkbox">').addClass(this.classes.checkbox).attr({ checked: getState() });

        this.render();
        setTimeout($.proxy(this.bindEvents, this), 0);
    },
    render: function(){

        this.els.tab.append(this.els.tabLink);
        this.els.menu.append(this.els.tab);

        this.els.label
            .append(this.els.checkbox)
            .append(this.config.label);

        this.els.block.append(this.els.label);
        this.els.container.prepend(this.els.block);
    },
    bindEvents: function(){

        this.els.block.hide();

        this.els.checkbox.change(function(){
            var checked = !!$(this).filter(':checked').length;
            localStorage.setItem('taist_taistieState', checked ? 'active' : 'inactive');
        });

        this.els.tabLink.click($.proxy(this.showSettings, this));
    },
    showSettings: function(){

        var header = this.els.header.html();
        header = header.replace(/Общая информация/, this.config.tabText);
        this.els.header.html(header);

        this.els.tabLink
            .removeClass(this.classes.inactive)
            .addClass(this.classes.active)
            .parent()
            .siblings()
            .children()
            .removeClass(this.classes.active)
            .addClass(this.classes.inactive);

        this.els.block.show();
    }
};

if ( getState() ) {
    $('body').addClass('taist_active');
    MentionTags.init();
}

if ( document.location.pathname === '/Workplace/Details' ) {
    Settings.init();
}

// for debug
window.MentionTags = MentionTags;
window.Settings = Settings;
window.getState = getState;
