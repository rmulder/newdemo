/**
 * Created by robertm on 12/5/13.
 */

function loadJS(url) {
  // adding the script tag to the head
  var head = document.getElementsByTagName('head')[0];
  var script = document.createElement('script');
  script.type = 'text/javascript';
  script.src = url;

  // fire the loading
  head.appendChild(script);
}

var browser = function () {
  var n = navigator.userAgent.toLowerCase();
  var b = {
    ie9: (/msie 9/.test(n)) && (!/opera/.test(n)),
    ie8: (/msie 8/.test(n)) && (!/opera/.test(n))
  };
  return b;
}();

if (browser.ie8 || browser.ie9) {
  var tmp = (browser.ie8)? ' ie8' : ' ie9';
  document.documentElement.className += tmp;
  if (browser.ie8) {
    //DSP = DSP || {resources_url: ''};
    loadJS(DSP.resources_url + 'js/selectivizr.js');
  }
}
