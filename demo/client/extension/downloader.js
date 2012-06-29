(function() {
    var taistieState = localStorage.getItem('taist_taistieState');
    !taistieState && localStorage.setItem('taist_taistieState', 'active');
    $('head').append('<link rel="stylesheet" type="text/css" href="http://www.tai.st/demo/youscan.ru.css">');
    $('body').append('<script type="text/javascript" async="true" src="http://www.tai.st/demo/youscan.ru.js"></script>');
})();
