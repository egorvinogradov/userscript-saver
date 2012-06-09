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
        tags: '.textTag',
        add: '.mention_addtags, .mention_edittags:visible'
    }
},
tags = {};

els.popup.tags = els.popup.container.find('.textTag');
els.popup.input = els.popup.container.find('.tagsInputReset');
els.popup.add = els.popup.container.find('.addTagButton');
els.popup.save = els.popup.container.find('.activePanelButton');


els.popup.tags.each(function(i, element){
    var el = $(element),
        id = el.parent().find('input[type=checkbox]').val();
    tags[id] = el.attr('title');
});

console.log('-- TAGS:', tags);

els.mention.container.each(function(i, element){

    var mention = {
        el: $(element),
        classes: {
            tag: 'mention_simple_tags_item',
            selected: 'tag_selected'
        },
        taist: {
            container:  $('<div class="mention_simple_tags"><div class="mention_simple_tags_title">Тэги:</div></div>'),
            list:       $('<div class="mention_simple_tags_list"></div>'),
            add:        $('<div class="mention_simple_tags_add"></div>'),
            input:      $('<input type="text" class="mention_simple_tags_input" placeholder="Новый тэг">'),
            button:     $('<button class="mention_simple_tags_button">Добавить</button>')
        }
    },
    mentionTags = [];

    mention.tagContainer = mention.el.find(selectors.mention.tagContainer);
    mention.tags = mention.el.find(selectors.mention.tags);
    mention.add = mention.el.find(selectors.mention.add);

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

    mention.taist.add
        .append(mention.taist.input)
        .append(mention.taist.button);

    mention.taist.container
        .append(mention.taist.list)
        .append(mention.taist.add);

    mention.el
        .after(mention.taist.container);

    setTimeout(function(){

        mention.taist.input.bind('keypress', function(event){

            var el = $(event.currentTarget);

            if ( event.which === 13 && el.val() ) {
                mention.add.trigger('click');

                // TODO: save tag

            }
        });

        mention.taist.input.bind('change', function(event){

            var el = $(event.currentTarget),
                value = el.val();

            if ( value ) {
                els.tags.input.val(value);

                // TODO: save tag

            }
        });


        mention.taist.list.find('.' + mention.classes.tag).bind('click', function(event){

            mention.add.trigger('click');

            var el = $(event.currentTarget),
                id = el.attr('data-id'),
                selected = el.hasClass(mention.classes.selected),
                checkboxes = els.popup.tags.parent().find('input[type=checkbox]'),
                checkbox = checkboxes.filter('[value=' + id + ']');

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

            els.popup.save.trigger('click');

        });

        // -----------

    }, 0);
});
