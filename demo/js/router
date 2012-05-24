var route = function(path){
    console.log('Route to ' + path);
};

exports.route = route;


/*

$(function(){

    var send = function(){

        var fb = $('#taist_facebook').val(),
            tw = $('#taist_twitter').val();

            // TODO: send to taist db



            $.ajax({
                url: 'http://127.0.0.1:8000/saasdemo',
                dataType: 'jsonp',
                data: {
                    user: 'anonymous',
                    field1: fb,
                    field2: tw,
                    format: 'json'
                },
                success: function(data){
                    console.log('--- data', data)
                },
                error: function(err){
                    console.log('--- error', err)
                }
            });

            alert('http://127.0.0.1:8000/saasdemo?user=anonymous&field1='+fb+'&field2='+tw+'&format=json');
        },
        get = function(){

            // TODO: get values from taist db

            $('#taist_facebook').val('');
            $('#taist_twitter').val('');

        };

    $('.b-userprofile-info:contains("День рождения")').find('.js-link-popup-form').click(function(){

        setTimeout(function(){
            $('#editForm').after('<div class="b-editor-row"><div class="editor-label">Facebook:&nbsp;</div>' +
                '<div class="editor-field"><input class="g-input-text" id="taist_facebook" ' +
                'type="text" value=""></div></div><div class="b-editor-row"><div class="editor-label">' +
                'Twitter:&nbsp;</div><div class="editor-field"><input class="g-input-text" id="taist_twitter" ' +
                'type="text" value=""></div></div>');
        }, 0);

        $('.b-popup .b-button:contains("Сохранить")').bind('click', send);
    });

    $('.b-popup').find('.b-popup__close, .b-button:contains("Отмена")').click(function(){
        $('.b-popup .b-button:contains("Сохранить")').unbind('click', send);
    });

    get();

});

*/









var send = function(){

    var fb = $('#taist_facebook').val(),
        tw = $('#taist_twitter').val();

        console.log('data sent');

    };

$('.b-userprofile-info:contains("Опыт работы")').find('.js-link-popup-form').click(function(){

    setTimeout(function(){
        $('#editForm').after('<div class="b-editor-row"><div class="editor-label">Facebook:&nbsp;</div>' +
            '<div class="editor-field"><input class="g-input-text" id="taist_facebook" ' +
            'type="text" value=""></div></div><div class="b-editor-row"><div class="editor-label">' +
            'Twitter:&nbsp;</div><div class="editor-field"><input class="g-input-text" id="taist_twitter" ' +
            'type="text" value=""></div></div>');
    }, 0);

//    $('.b-popup .b-button:contains("Сохранить")').bind(send);
});

$('.b-popup').find('.b-popup__close, .b-button:contains("Отмена")').click(function(){
    $('.b-popup .b-button:contains("Сохранить")').unbind(send);
});












