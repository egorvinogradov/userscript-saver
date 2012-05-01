$(function(){

    var Promo = {

        settings: {
            pageWidth: 1000,
            slideCount: 3
        },
        els: {
            body:       $('.page'),
            forms:      $('.header__join-form, .footer__subscribe-form'),
            team: {
                block:  $('.team'),
                popup:  $('.team__popup'),
                close:  $('.team__popup-close-button'),
                link:   $('.footer__link-team')
            },
            slides: {
                headers:    $('.capabilities__header'),
                wrapper:    $('.capabilities__slides-wrapper'),
                switchers:  $('.capabilities__switcher'),

                headerContainer:    $('.capabilities__headers-list'),
                slideContainer:     $('.capabilities__slides'),
                switcherContainer:  $('.capabilities__switcher'),
                fading: {
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
                invisible:  'm-invisible',
                hover:      'm-hover'
            },
            switcherActive:     'm-active',
            fadingInvisible:    'm-invisible',
            inputError:         'm-error'
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
            return this.els.slides.headers.filter('.' + this.classes.headers.active).index();
        },
        switchSlide: function(number){

            var settings = {
                    pageWidth: 1000,
                    headerSpace: 40
                },
                header = this.els.slides.headers.eq(number),
                fading = this.els.slides.fading.all,
                animate = function(){

                    settings.headerIndents = settings.pageWidth - ( settings.pageWidth - header.width() ) / 2 + settings.headerSpace;

                    header
                        .next().css({ left: settings.headerIndents }).end()
                        .prev().css({ right: settings.headerIndents }).end()
                        .siblings().hide().fadeIn(600);

                    fading.width( ( settings.pageWidth - header.width() ) / 2 );
                };

            this.els.slides.headers
                .removeClass(this.classes.headers.active)
                .removeClass(this.classes.headers.left)
                .removeClass(this.classes.headers.hover)
                .removeClass(this.classes.headers.right)
                .addClass(this.classes.headers.invisible)
                .removeAttr('style');

            this.els.slides.wrapper
                .animate({ left: number * -1000 });

            this.els.slides.switchers
                .removeClass(this.classes.switcherActive)
                .eq(number).addClass(this.classes.switcherActive);

            header
                .addClass(this.classes.headers.active).removeClass(this.classes.headers.invisible)
                .next().addClass(this.classes.headers.right).removeClass(this.classes.headers.invisible).end()
                .prev().addClass(this.classes.headers.left).removeClass(this.classes.headers.invisible);

            fading
                .removeClass(this.classes.fadingInvisible);

            number === 0 && this.els.slides.fading.left.addClass(this.classes.fadingInvisible);
            number === this.settings.slideCount - 1 && this.els.slides.fading.right.addClass(this.classes.fadingInvisible);

            setTimeout(animate, 0);

        },
        validateEmail: function(input){

            var email = input.val(),
                re = /^([a-z0-9_\.\-])+\@(([a-z0-9\-])+\.)+([a-z0-9]{2,6})+$/i;

            if ( re.test(email) ) {
                return true;
            }
            else {
                input
                    .addClass(this.classes.inputError)
                    .one('blur', $.proxy(function(){
                        input.removeClass(this.classes.inputError)
                    }, this));

                return false;
            }
        },
        init: function(){

            var context = this,
                slideFirst = function(){
                    context.switchSlide( context.getNextSlide( context.getCurrentSlide() ) );
                },
                handlers = {

                    fadingClick: function(event){

                        var className = $(event.target).attr('class'),
                            current =   this.getCurrentSlide(),
                            isLeft =    className.indexOf('left') > -1,
                            isRight =   className.indexOf('right') > -1,
                            slide = isLeft
                                ? this.getPrevSlide(current)
                                : isRight
                                    ? this.getNextSlide(current)
                                    : false;

                        this.switchSlide(slide);
                    },
                    fadingHover: function(event){

                        var className = $(event.target).attr('class'),
                            hover =     this.classes.headers.hover,
                            isLeft =    className.indexOf('left') > -1,
                            isRight =   className.indexOf('right') > -1,
                            selector =
                                isLeft  && this.classes.headers.left ||
                                isRight && this.classes.headers.right,

                            header = this.els.slides.headers.filter('.' + selector);

                        event.type === 'mouseover'  && header.addClass(hover);
                        event.type === 'mouseout'   && header.removeClass(hover);
                    }
                };


            this.els.slides.fading.all = this.els.slides.fading.left.add(this.els.slides.fading.right);
            this.els.team.link.click($.proxy(this.showTeam, this));
            this.els.body.bind('click keydown', $.proxy(function(event){

                var target = $(event.target),
                    condition = ( event.type === 'keydown' && event.which === 27 ) ||
                                ( event.type === 'click' && ( target.is(this.els.team.close) || target.is(this.els.team.block) ) );

                condition && this.hideTeam();
                event.stopPropagation();

            }, this));


            this.els.slides.switchers.click($.proxy(function(event){
                this.switchSlide( $(event.target).index() );
            }, this));


            this.els.slides.fading.all
                .click($.proxy(handlers.fadingClick, this))
                .bind('mouseover mouseout', $.proxy(handlers.fadingHover, this));


            this.els.forms.each($.proxy(function(i, element){

                var form =  $(element),
                    input = form.find('input');

                form.submit($.proxy(function(){
                    return this.validateEmail(input);
                }, this));

            }, this));


            setTimeout(slideFirst, 1600);
        }
    };

    Promo.init();

});