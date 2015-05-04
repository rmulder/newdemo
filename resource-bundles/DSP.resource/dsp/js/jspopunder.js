/*
 js-popunder
 pure javascript function for creating pop-under windows
 https://github.com/tuki/js-popunder
 */
function jsPopunder(sUrl, sConfig) {
  var _parent = (top != self && typeof(top.document.location.toString()) === 'string') ? top : self;
  var popunder = null;

  sConfig = (sConfig || {});

  var sName = (sConfig.name || Math.floor((Math.random() * 1000) + 1));
  var sWidth = (sConfig.width || window.outerWidth || window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth);
  var sHeight = (sConfig.height || (window.outerHeight - 100) || window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight);

  var sPosX = (typeof(sConfig.left) != 'undefined') ? sConfig.left.toString() : window.screenX;
  var sPosY = (typeof(sConfig.top) != 'undefined') ? sConfig.top.toString() : window.screenY;

  var browser = function () {
    var n = navigator.userAgent.toLowerCase();
    var b = {
      ipad: /ipad/.test(n),
      webkit: /webkit/.test(n),
      mozilla: (/mozilla/.test(n)) && (!/(compatible|webkit)/.test(n)),
      chrome: /chrome/.test(n),
      msie: (/msie/.test(n)) && (!/opera/.test(n)),
      ie8: (/msie 8/.test(n)) && (!/opera/.test(n)),
      firefox: /firefox/.test(n),
      safari: (/safari/.test(n) && !(/chrome/.test(n))),
      opera: /opera/.test(n)
    };
    b.version = (b.safari) ? (n.match(/.+(?:ri)[\/: ]([\d.]+)/) || [])[1] : (n.match(/.+(?:ox|me|ra|ie)[\/: ]([\d.]+)/) || [])[1];
    return b;
  }();


  function popUnder(url, width, height) {
    var popUnderWin, nav = navigator.userAgent,
        isGecko = /rv:[2-9]/.exec(nav),
        hackString;

    hackString = nav.indexOf('Chrome') > -1 ? "scrollbar=yes" : "toolbar=0,statusbar=1,resizable=1,scrollbars=0,menubar=0,location=1,directories=0";
    popUnderWin = window.open("about:blank", "title", hackString + ",height=" + height + ",width=" + width);

    if (isGecko) {
      popUnderWin.window.open("about:blank").close();
    }
    popUnderWin.document.location.href = url;

    setTimeout(window.focus);
    window.focus();
    popUnderWin.blur();
    path = window.document.URL;
    window.open(path,"_self");
  }

  function doPopunder(sUrl, sName, sWidth, sHeight, sPosX, sPosY) {
    var sOptions = 'toolbar=no,scrollbars=yes,location=yes,statusbar=yes,menubar=no,resizable=1,width=' + sWidth.toString() + ',height=' + sHeight.toString() + ',screenX=' + sPosX + ',screenY=' + sPosY,
    path, x = 0, y = 0;

    if (browser.ie8) {
      popunder = _parent.window.open(sUrl, '_blank', sOptions);
    } else {
      popunder = _parent.window.open(sUrl, sName, sOptions);
    }

    if (browser.ipad) {
      setTimeout(window.focus);
      window.focus();
      popunder.blur();
      if (browser.ipad) {
        //path = window.document.URL;
        //x = window.pageXOffset;
        //y = window.pageYOffset;
/*
        if (typeof jQuery === 'function') {
          pos = jQuery('body').scrollTop();
        }
*/
        //var win = window.open(path,"_self");
        //win.document.write("<script>window.scrollTo(" + x + ", " + y + ");</script>");
/*
        if (typeof jQuery === 'function') {
          jQuery('body').scrollTop(pos);
        }
*/
        //win.scrollTo(x, y);
      }
    } else {
      //console.log('scrollTop:', window.pageXOffset, window.pageYOffset);
      /*if (popunder) {
        pop2under();
      } */
    }
  }


  function pop2under() {
    try {
      //popunder.blur();
      popunder.opener.window.focus();
      //window.self.window.focus();
      //window.focus();

      //if (browser.firefox) openCloseWindow();
      //if (browser.webkit) openCloseTab();
      if (browser.msie) {
        setTimeout(function () {
          //popunder.blur();
          popunder.opener.window.focus();
          //window.self.window.focus();
          //window.focus();
        }, 1000);
      }
    } catch (e) {
    }
  }

  function openCloseWindow() {
    var ghost = window.open('about:blank');
    ghost.focus();
    ghost.close();
  }

  function openCloseTab() {
    var nothing = '';
    var ghost = document.createElement("a");
    ghost.href = "data:text/html,<scr" + nothing + "ipt>window.close();</scr" + nothing + "ipt>";
    document.getElementsByTagName("body")[0].appendChild(ghost);

    var clk = document.createEvent("MouseEvents");
    clk.initMouseEvent("click", false, true, window, 0, 0, 0, 0, 0, true, false, false, true, 0, null);
    ghost.dispatchEvent(clk);

    ghost.parentNode.removeChild(ghost);
  }

  doPopunder(sUrl, sName, sWidth, sHeight, sPosX, sPosY);
}