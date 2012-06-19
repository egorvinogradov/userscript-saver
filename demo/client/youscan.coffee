if not console or not console.log
	console =
		log: ->

els =
	mention:
		container: $('.mention_item')
	popup:
		container: $('.mentionTagsList')

selectors =
	mention:
		tagContainer: '[id^="mentionIdForTags"]'
		middleBlock: '.mention_middle_block'
		tags: '.textTag'
		remove: '.tagRemoveBtn'
		addButton: '.mention_addtags, .mention_edittags:visible'

tags = {}
TOTAL_TAG_COUNT = 20
MAX_MENTION_TAG_COUNT = 5

els.popup.tags = els.popup.container.find '.textTag'
els.popup.input = els.popup.container.find '.tagsInputReset'
els.popup.addButton = els.popup.container.find '.addTagButton'
els.popup.save = els.popup.container.find '.activePanelButton'

els.popup.tags.each (i, element ) ->
	el = $(element)
	id = el.parent().find('input[type=checkbox]').val
	tags.id = el.attr('title').toLowerCase

els.mention.container.each (i, element) ->

	mention =
		el: $(element)
		classes:
			tag: 'mention_simple_tags_item'
			text: 'mention_simple_tags_text'
			remove: 'mention_simple_tags_remove'
			selected: 'tag_selected'
			highlighted: 'tag_highlighted'
		taist:
			container: $('<div class="mention_simple_tags"><div class="mention_simple_tags_title">Тэги:</div></div>')
			list: $('<div class="mention_simple_tags_list"></div>')
			addBlock: $('<div class="mention_simple_tags_add"></div>')
			input: $('<input type="text" class="mention_simple_tags_input" placeholder="Новый тэг">')
			button: $('<button class="mention_simple_tags_button">Добавить</button>')

	methods =
		toggleTag: element ->

			handler = event ->
				el = $(event.currentTarget)
				id = el.attr 'data-id'
				selected = el.hasClass mention.classes.selected
				checkboxes = els.popup.tags.parent().find 'input[type=checkbox]'
				checkbox = checkboxes.filter '[value="#{id}"]'

				if mention.taist.list.find('.#{mention.classes.tag}.#{mention.classes.selected}').length and not selected
					alert 'Достигнут лимит выбранных тэгов для одного упоминания.'
					return false

				mention.addButton.trigger 'click'

				mention.taist.list.find('.#{mention.classes.tag}.#{mention.classes.selected}').each (i, e) ->
					checkboxes.filter('[value=' + $(e).attr 'data-id' + ']').attr checked: true

				if selected
					checkbox.attr checked: false
					el.removeClass mention.classes.selected
				else
					checkbox.attr checked: true
					el.addClass mention.classes.selected

				setTimeout @setTagBlockHeight, 0

				try
					els.popup.save.trigger 'click'
				finally
					@checkErrors

			element.bind 'click', $.proxy(handler, @)

		addTagByEnterPress: element ->

			handler = event ->
				el = $(event.currentTarget)
				value = el.val

				if event.which is 13 and value
					@addTag value
					el.val('').focus

			element.bind 'keypress', $.proxy(handler, @)

		addTagByButtonPress: element ->

			handler = event ->
				el = $(event.currentTarget)
				input = el.siblings mention.taist.input
				value = input.val

				if value
					@addTag value
					input.val('').focus

			element.bind 'click', $.proxy(handler, @)

		addTag: value ->

			if not value
				return false

			if els.popup.tags.length >= TOTAL_TAG_COUNT
				alert 'Достигнут лимит по количеству тегов для темы.'
				return false

			if mention.taist.list.find('.#{mention.classes.tag}.#{mention.classes.selected}').length >= MAX_MENTION_TAG_COUNT
				alert 'Достигнут лимит выбранных тэгов для одного упоминания.'
				return false

			mention.addButton.trigger 'click'
			els.popup.input.val value
			els.popup.addButton.trigger 'click'
			els.popup.tags = els.popup.container.find selectors.mention.tags
			els.popup.tags.each (i, element) ->
				el = $(element)
				if el.html is value
					popupTagCheckbox = el.parent().find 'input[type=checkbox]'

			checkboxes = els.popup.tags.parent().find 'input[type=checkbox]'
			popupTagCheckbox.attr checked: true
			mention.taist.list.find('.#{mention.classes.tag}.#{mention.classes.selected}').each (i, e) ->
				checkboxes.filter('[value=' + $(e).attr 'data-id' + ']').attr checked: true

			newTagId = 0
			newTag = $('<div class="#{mention.classes.tag} #{mention.classes.selected}" data-id="#{newTagId}">#{value}</div>')
			mention.taist.list.append newTag

			sorting = (a, b) ->
				if $(a).html < $(b).html then -1 else 1

			mention.taist.list.find('.#{mention.classes.tag}').sort(sorting).appendTo mention.taist.list.empty
			newTag.addClass mention.classes.highlighted

			afterRender = ->
				@toggleTag mention.taist.list.find('.#{mention.classes.tag}')
				@setTagBlockHeight

			setTimeout $.proxy(afterRender, @), 0
			setTimeout -> newTag.removeClass mention.classes.highlighted, 1000

			try
				els.popup.save.trigger 'click'
			finally
				@checkErrors

			console.log 'add new tag:', new Date().toString, +new Date
			tagCount = mention.tags.length

			onNewTagReady = ->
				console.log 'check new tag:', new Date().toString, +new Date
				if mention.el.find(selectors.mention.tags).length > tagCount
					clearInterval newTagReady
					mention.tags = mention.el.find selectors.mention.tags
					newTagId = mention.tags.parent().filter(':contains("#{value}")').attr 'id'
					mention.taist.list.find('.#{mention.classes.tag}').filter(':contains("#{value}")').attr 'data-id' : newTagId
					console.log 'new tag ready:', new Date().toString, +new Date

			newTagReady = setInterval onNewTagReady, 1000

		setTagBlockHeight: ->
			height = mention.taist.list.height
			mention.taist.container.css 'marginTop' : '#{ ( 83 + height ) * -1 }px'
			mention.middleBlock.css 'paddingBottom' : '#{ 40 + height }px'

		checkErrors: ->
			handler = ->
				if els.popup.container.filter(':visible').length
					alert 'Произошла ошибка. Пожалуйста, перезагрузите страницу.'

			setTimeout handler, 1000

		mentionTags: []
		resizeTimer: false

	mention.tagContainer = mention.el.find selectors.mention.tagContainer
	mention.middleBlock = mention.el.find selectors.mention.middleBlock
	mention.tags = mention.el.find selectors.mention.tags
	mention.addButton = mention.el.find selectors.mention.addButton

	for id, text of tags
		do ->
			mentionTags.push
				id: id
				text: text
				selected: mention.tags.parent().filter('[id=#{id}]').length

	mentionTags.sort (a, b) ->
		if a.text < b.text then -1 else 1

	for tag in mentionTags
		do (tag) ->
			el = $('<div class="#{mention.classes.tag}' + if tag.selected then ' #{ mention.classes.selected }' + '" data-id="#{tag.id}">#{tag.text}</div>')
			mention.taist.list.append el
	


#    $.each(mentionTags, function(i, t){
#        var el = $('<div class="'+mention.classes.tag+(t.selected ? ' '+mention.classes.selected : '')+'" data-id="'+t.id+'">'+t.text+'</div>');
#        mention.taist.list.append(el);
#    });
#
#    mention.tagContainer.hide();
#
#    mention.taist.addBlock
#        .append(mention.taist.input)
#        .append(mention.taist.button);
#
#    mention.taist.container
#        .append(mention.taist.list)
#        .append(mention.taist.addBlock);
#
#    mention.el
#        .after(mention.taist.container);















#mentionTags = for child, age of yearsOld
#  "#{child} is #{age}"
#
#
#mentionTags = (math.cube num for num in list)



#els.mention.container.each(function(i, element){
#
#
#    $.each(mentionTags, function(i, t){
#        var el = $('<div class="'+mention.classes.tag+(t.selected ? ' '+mention.classes.selected : '')+'" data-id="'+t.id+'">'+t.text+'</div>');
#        mention.taist.list.append(el);
#    });
#
#    mention.tagContainer.hide();
#
#    mention.taist.addBlock
#        .append(mention.taist.input)
#        .append(mention.taist.button);
#
#    mention.taist.container
#        .append(mention.taist.list)
#        .append(mention.taist.addBlock);
#
#    mention.el
#        .after(mention.taist.container);
#
#
#    cssReady = setInterval(function(){
#        if ( mention.taist.container.eq(0).css('overflow') === 'hidden' ) {
#            clearInterval(cssReady);
#            methods.setTagBlockHeight();
#            methods.toggleTag(mention.taist.list.find('.' + mention.classes.tag));
#            methods.addTagByEnterPress(mention.taist.input);
#            methods.addTagByButtonPress(mention.taist.button);
#        }
#    }, 100);
#
#
#    $(window).resize(function(event){
#        if ( resizeTimer ) return false;
#        resizeTimer = true;
#        setTimeout(function(){
#            resizeTimer = false;
#            methods.setTagBlockHeight();
#        }, 100);
#    });
#
#    if ( !( 'placeholder' in mention.taist.input[0] ) ) {
#        mention.taist.input
#            .val( mention.taist.input.attr('placeholder') )
#            .one('focus', function(){
#                $(this).val('');
#            });
#    }
#
#});
#
#
##//<span class="mention_simple_tags_title"></span>
##//<span class="mention_simple_tags_remove"></span>
#
#
