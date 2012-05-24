var http = require('http'),
    url = require('url'),
    querystring = require('querystring'),
    mongo = require('mongodb'),
    Server = mongo.Server,
    Db = mongo.Db,
    //router = require('./router'),
    demo = function(req, res){

        var temp = [],
            path = url.parse(req.url),
            server = new Server('localhost', 27017, {auto_reconnect: true}),
            db = new Db('demo123', server),
            query = querystring.parse(path.query),
            outputHTML = function(query, dbItems){

                var db = [],
                    params = [];

                for ( var i = 0, l = dbItems.length; i < l; i++ ) {
                    db.push(JSON.stringify(dbItems[i]));
                }

                for ( var param in query ) {
                    params.push('<b>' + param + '</b>: ' + query[param]);
                }

                res.writeHead(200, {
                    'Content-Type': 'text/html'
                });

                res.write(
                        '<h1>200 OK:</h1><hr>' + req.url + '<hr>' +
                        '<h2>Params:</h2> &mdash; ' + params.join('<br> &mdash; ') + '<hr>' +
                        '<h2>DB:</h2> &mdash; ' + db.join('<br> &mdash; ') + '<hr>');

            },
            outputJSON = function(query, items, callback){

                callback = callback || 'eval';

                res.writeHead(200, {
                    'Content-Type': 'application/javascript'
                });

                res.write(callback + '(' + JSON.stringify(items[0]) +')');

            },
            updateDB = function(){

                db.open(function(err, db) {

                    if( !err ) {

                        db.collection('test', function(err, collection) {

                            var data = {};

                            data[query.user] = {
                                date: new Date().toString(),
                                field1: query.field1,
                                field2: query.field2
                            };

                            //collection.remove();
                            collection.insert(data);
                            collection.find().toArray(function(err, items) {

                                query.format && query.format.toLocaleLowerCase() === 'json'
                                    ? outputJSON(query, items, query.callback)
                                    : outputHTML(query, items);

                                res.end();

                            });

                        });
                    }
                });
            },
            showError = function(){

                res.writeHead(404, {
                    'Content-Type': 'text/html'
                });
                res.write('<h1>Error 404</h1><hr>' + req.url + '<hr>');

                res.end();

            };


        path.pathname === '/saasdemo'
            ? updateDB()
            : showError();


    },
    start = function(){
        http.createServer(demo).listen(8000);
        console.log('Server created');
    };

exports.start = start;






//                            collection.insert({ date: new Date().toString() });
//                            collection.update(data, {$set: data}, function(err, result){
//                                console.log('--UPDATE', result, err);
//                            });






//        var data = document.getElementById('uni-account-title')
//                .getElementsByTagName('ul')[0]
//                .getElementsByTagName('li')[0]
//                .getElementsByTagName('a')[0]
//                .href.split('yammer.com/')[1].split('/users/'),
//            company = data[0],
//            user = data[1];

//        YAM.User.name
//        YAM.User.id
//        YAM.User.network_id




// http://127.0.0.1:8000/saasdemo?user=anonymous&field1=Hello&field2=World&format=json

//$.ajax({
//    url: 'http://127.0.0.1:8000/saasdemo',
//    dataType: 'jsonp',
//    data: {
//        user: 'anonymous',
//        field1: 'Hello',
//        field2: 'World',
//        format: 'json'
//    },
//    success: function(data){
//        console.log('--- data', data)
//    },
//    error: function(err){
//        console.log('--- error', err)
//    }
//});
