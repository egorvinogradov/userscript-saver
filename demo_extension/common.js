var YouScan = {
    config: {
        urlRe: /^(?:http|https):\/\/(?:www\.)?youscan\.(?:ru|biz)/,
        downloader: 'chrome-extension://endbdphokblkdiglihhkmcaihnlemndp/downloader.js'
    },
    init: function(){
        console.log('Taist extension: init');
        this.bindTabUpdate(function(tabId, url){
            if ( this.config.urlRe.test(url) ) {
                this.insertJS(tabId, this.config.downloader);
            }
        });
    },
    bindTabUpdate: function(callback){
        var _this = this;
        chrome.tabs.onUpdated.addListener(function(tabId, changeInfo, tab){
            if ( changeInfo.status === 'complete' ) {
                console.log('Taist extension: tab updated', tab.url, tabId, changeInfo, tab);
                callback.call(_this, tabId, tab.url);
            }
        });
    },
    insertJS: function(tabId, path){
        var code = '(' + this.appendDownloader.toString() + '(\'' + path + '\'))';
        chrome.tabs.executeScript(tabId, { code: code }, function(){
            console.log('Taist extension: insert JS', tabId, path, code);
        });
    },
    appendDownloader: function(path){
        var script = document.createElement('script');
        script.type = 'text/javascript';
        script.src = path;
        document.body.appendChild(script);
        console.log('Taist initialization', path);
    }
};
