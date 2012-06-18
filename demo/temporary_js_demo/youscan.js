if ( !console || !console.log ) {
    console = {
        log: function(){}
    };
}

var els = {
        mention: {
            container: $('.mention_item')
        },
        popup: {
            container: $('.mentionTagsList')
        }
    },
    selectors = {
        mention: {
            tagContainer: '[id^="mentionIdForTags"]',
            middleBlock: '.mention_middle_block',
            tags: '.textTag',
            remove: '.tagRemoveBtn',
            addButton: '.mention_addtags, .mention_edittags:visible'
        }
    },
    tags = {},
    TOTAL_TAG_COUNT = 20,
    MAX_MENTION_TAG_COUNT = 5;

els.popup.tags = els.popup.container.find('.textTag');
els.popup.input = els.popup.container.find('.tagsInputReset');
els.popup.addButton = els.popup.container.find('.addTagButton');
els.popup.save = els.popup.container.find('.activePanelButton');

window.els = els;
window.mmm = [];

els.popup.tags.each(function(i, element){
    var el = $(element),
        id = el.parent().find('input[type=checkbox]').val();
    tags[id] = el.attr('title').toLowerCase();
});

els.mention.container.each(function(i, element){

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
            addBlock:  $('<div class="mention_simple_tags_add"></div>'),
            input:      $('<input type="text" class="mention_simple_tags_input" placeholder="Новый тэг">'),
            button:     $('<button class="mention_simple_tags_button">Добавить</button>')
        }
    },
    methods = {
        toggleTag: function(element){

            element.bind('click', $.proxy(function(event){

                var el = $(event.currentTarget),
                    id = el.attr('data-id'),
                    selected = el.hasClass(mention.classes.selected),
                    checkboxes = els.popup.tags.parent().find('input[type=checkbox]'),
                    checkbox = checkboxes.filter('[value=' + id + ']');

                if ( mention.taist.list.find('.' + mention.classes.tag + '.' + mention.classes.selected).length >= MAX_MENTION_TAG_COUNT && !selected ) {
                    alert('Достигнут лимит выбранных тэгов для одного упоминания.');
                    return false;
                }

                mention.addButton.trigger('click');

                mention.taist.list
                    .find('.' + mention.classes.tag + '.' + mention.classes.selected)
                    .each(function(i, e){
                        checkboxes.filter('[value=' + $(e).attr('data-id') + ']').attr({ checked: true });
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
                    this.setTagBlockHeight();
                }, this), 0);

                try {
                    els.popup.save.trigger('click');
                }
                finally {
                    this.checkErrors();
                }

            }, this));
        },
        addTagByEnterPress: function(element){

            element.bind('keypress', $.proxy(function(event){

                var el = $(event.currentTarget),
                    value = el.val();

                if ( event.which === 13 && value ) {
                    this.addTag(value);
                    el.val('').focus();
                }

            }, this));

        },
        addTagByButtonPress: function(element){

            element.bind('click', $.proxy(function(event){

                var el = $(event.currentTarget),
                    input = el.siblings(mention.taist.input),
                    value = input.val();

                if ( value ) {
                    this.addTag(value);
                    input.val('').focus();
                }

            }, this));

        },
        addTag: function(value){

            if ( !value ) {
                return false;
            }

            if ( els.popup.tags.length >= TOTAL_TAG_COUNT ) {
                alert('Достигнут лимит по количеству тегов для темы.');
                return false;
            }

            if ( mention.taist.list.find('.' + mention.classes.tag + '.' + mention.classes.selected).length >= MAX_MENTION_TAG_COUNT ) {
                alert('Достигнут лимит выбранных тэгов для одного упоминания.');
                return false;
            }

            var checkboxes = els.popup.tags.parent().find('input[type=checkbox]'),
                tagCount = mention.tags.length,
                popupTagCheckbox,
                newTag,
                newTagReady,
                newTagId = 0;

            mention.addButton.trigger('click');
            els.popup.input.val(value);
            els.popup.addButton.trigger('click');

            els.popup.tags = els.popup.container.find(selectors.mention.tags);
            els.popup.tags.each(function(i, element){
                var el = $(element);
                if ( el.html() === value ) {
                    popupTagCheckbox = el.parent().find('input[type=checkbox]');
                }
            });

            popupTagCheckbox.attr({ checked: true });

            mention.taist.list
                .find('.' + mention.classes.tag + '.' + mention.classes.selected)
                .each(function(i, e){
                    checkboxes.filter('[value=' + $(e).attr('data-id') + ']').attr({ checked: true });
                });

            newTag = $('<div class="'+mention.classes.tag+ ' ' + mention.classes.selected +'" data-id="'+ newTagId +'">'+value+'</div>');

            mention.taist.list.append(newTag);

            mention.taist.list
                .find('.' + mention.classes.tag)
                .sort(function(a,b){ return $(a).html() < $(b).html() ? -1 : 1; })
                .appendTo( mention.taist.list.empty() );

            newTag.addClass(mention.classes.highlighted);

            setTimeout($.proxy(function(){
                this.toggleTag(mention.taist.list.find('.' + mention.classes.tag));
                this.setTagBlockHeight();
            }, this), 0);

            setTimeout(function(){
                newTag.removeClass(mention.classes.highlighted);
            }, 1000);

            try {
                els.popup.save.trigger('click');
            }
            finally {
                this.checkErrors();
            }

            console.log('add new tag:',
                +new Date(),
                new Date().toString(),
                value
            );

            newTagReady = setInterval(function(){

                console.log('check new tag:',
                    +new Date(),
                    new Date().toString(),
                    mention.el.find(selectors.mention.tags).length,
                    mention.el.find(selectors.mention.tags)
                );

                if ( mention.el.find(selectors.mention.tags).length > tagCount ) {

                    clearInterval(newTagReady);
                    mention.tags = mention.el.find(selectors.mention.tags);

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

            }, 1000);

        },
        setTagBlockHeight: function(){
            var height = mention.taist.list.height();
            mention.taist.container.css({ marginTop: ( 83 + height ) * -1 + 'px' });
            mention.middleBlock.css({ paddingBottom: 40 + height + 'px' });
        },
        checkErrors: function(){
            setTimeout(function(){
                if ( els.popup.container.filter(':visible').length ) {
                    alert('Произошла ошибка. Пожалуйста, перезагрузите страницу.');
                }
            }, 1000);
        }
    },
    mentionTags = [],
    resizeTimer = false,
    cssReady;

    window.mmm.push(mention);

    mention.tagContainer = mention.el.find(selectors.mention.tagContainer);
    mention.middleBlock = mention.el.find(selectors.mention.middleBlock);
    mention.tags = mention.el.find(selectors.mention.tags);
    mention.addButton = mention.el.find(selectors.mention.addButton);

    for ( var tagId in tags ) {

        var tagData = {
            id: tagId,
            text: tags[tagId],
            selected: mention.tags.parent().filter('[id=' + tagId + ']').length
        };

        mentionTags.push(tagData);
    }

    mentionTags.sort(function(a, b){
        return a.text < b.text ? -1 : 1;
    });

    $.each(mentionTags, function(i, t){
        var el = $('<div class="'+mention.classes.tag+(t.selected ? ' '+mention.classes.selected : '')+'" data-id="'+t.id+'">'+t.text+'</div>');
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


    cssReady = setInterval(function(){
        if ( mention.taist.container.eq(0).css('overflow') === 'hidden' ) {
            clearInterval(cssReady);
            methods.setTagBlockHeight();
            methods.toggleTag(mention.taist.list.find('.' + mention.classes.tag));
            methods.addTagByEnterPress(mention.taist.input);
            methods.addTagByButtonPress(mention.taist.button);
        }
    }, 100);


    $(window).resize(function(event){
        if ( resizeTimer ) return false;
        resizeTimer = true;
        setTimeout(function(){
            resizeTimer = false;
            methods.setTagBlockHeight();
        }, 100);
    });

    if ( !( 'placeholder' in mention.taist.input[0] ) ) {
        mention.taist.input
            .val( mention.taist.input.attr('placeholder') )
            .one('focus', function(){
                $(this).val('');
            });
    }

});


//<span class="mention_simple_tags_title"></span>
//<span class="mention_simple_tags_remove"></span>


