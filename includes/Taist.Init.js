// ==UserScript==
// @include http://*/*
// @include https://*/*
// ==/UserScript==
chrome.extension.sendRequest({action: 'startTaistingUp', url: document.location.href});
