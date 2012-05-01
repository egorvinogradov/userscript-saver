$(function(){

    var Promo = {

        settings: {
            pageWidth: 1000,
            slideCount: 3
        },
        els: {
            body: $('.page'),
            team: {
                block:  $('.team'),
                popup:  $('.team__popup'),
                close:  $('.team__popup-close-button'),
                link:   $('.footer__link-team')
            },
            slides: {
                headers:    $('.capabilities__header'),
                slides:     $('.capabilities__slide-steps'),
                switchers:  $('.capabilities__switcher'),
                headerContainer:    $('.capabilities__headers-list'),
                slideContainer:     $('.capabilities__slides'),
                switcherContainer:  $('.capabilities__switcher'),
                fade: {
                    left:   $('.capabilities__headers-fading-left'),
                    right:  $('.capabilities__headers-fading-right')
                }
            }
        },
        classes: {
            headers: {
                active:     'm-active',
                left:       'm-left',
                right:      'm-right',
                invisible:  'm-invisible'
            },
            slideActive:    'm-active',
            switcherActive: 'm-active',
            fadeInvisible:  'm-invisible'
        },

        showTeam: function(){
            this.els.team.block.show();
            this.els.team.popup.hide().fadeIn();
        },
        hideTeam: function(){
            this.els.team.popup.fadeOut($.proxy(function(){
                this.els.team.block.hide();
            }, this));
        },
        getNextSlide: function(current){
            return current + 1 < this.settings.slideCount ? current + 1 : 0;
        },
        getPrevSlide: function(current){
            return current - 1 > -1 ? current - 1 : this.settings.slideCount - 1;
        },
        getCurrentSlide: function(){
            return this.els.slides.slides.filter('.' + this.classes.slideActive).index();
        },
        switchSlide: function(number){

            var settings = {
                    pageWidth: 1000,
                    headerSpace: 40
                },
                els = {
                    header: this.els.slides.headers.eq(number),
                    slide: this.els.slides.slides.eq(number),
                    switcher: this.els.slides.slides.eq(number),
                    fade: this.els.slides.fade.left.add(this.els.slides.fade.left)
                },
                animate = function(){

                    var headerWidth = els.header.width(),
                        headerIndents = settings.pageWidth - ( settings.pageWidth - headerWidth ) / 2 + settings.headerSpace;

                    settings.headerIndents = headerIndents;
                    els.header
                        .next().css({ left: headerIndents }).end()
                        .prev().css({ right: headerIndents });

                    els.slide.css({ left: '100%' }).animate({ left: 0 });
                    els.header.siblings()
                        .hide().fadeIn().css({ display: '' });
                };

            this.els.slides.slides.removeClass(this.classes.slideActive);
            this.els.slides.headers
                .removeClass(this.classes.headers.active)
                .removeClass(this.classes.headers.left)
                .removeClass(this.classes.headers.right)
                .removeAttr('style')
                .addClass(this.classes.headers.invisible);

            els.slide.addClass(this.classes.slideActive);
            els.header.addClass(this.classes.headers.active).removeClass(this.classes.headers.invisible)
                .next().addClass(this.classes.headers.right).removeClass(this.classes.headers.invisible).end()
                .prev().addClass(this.classes.headers.left).removeClass(this.classes.headers.invisible);

            this.els.slides.switchers
                .removeClass(this.classes.switcherActive)
                .eq(number).addClass(this.classes.switcherActive);

            setTimeout(animate, 0);

        },
        init: function(){

            this.els.team.link.click($.proxy(this.showTeam, this));
            this.els.body.bind('click keydown', $.proxy(function(event){

                var condition = ( event.type === 'keydown' && event.which === 27 ) ||
                                ( event.type === 'click' && $(event.target).is(this.els.team.close) );

                condition && this.hideTeam();
                event.stopPropagation();

            }, this));

            this.els.slides.switchers.click($.proxy(function(event){
                this.switchSlide( $(event.target).index() );
            }, this));

            this.els.slides.fade.left
                .add(this.els.slides.headers.filter('.' + this.classes.headers.left))
                .click($.proxy(function(){
                    this.switchSlide( this.getPrevSlide(this.getCurrentSlide()) );
                }, this));

            this.els.slides.fade.right
                .add(this.els.slides.headers.filter('.' + this.classes.headers.right))
                .click($.proxy(function(){
                    this.switchSlide( this.getNextSlide(this.getCurrentSlide()) );
                }, this));
        }
    };

    Promo.init();

    window.promo = Promo; // TODO: remove;

});