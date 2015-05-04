/*!
 * Common jQuery methods for DSP project
 *
 * Copyright 2014 Terafina Inc.
 */
if (window.console === undefined) {
  window.console = {
    log: function(){},
    error: function(){}
  }
}

$j = jQuery.noConflict();
$j(document).ready(function () {
  $j('.help-link').on('click', function (e) {
    var panel = $j('#dropdown-panel'), cpanel = panel.find('.panel-content'), phone, email, parts;

    cpanel.html($j('#helpPanel').html());
    $j(cpanel).find('h3').addClass('uppercase');
    $j(cpanel).find('.cfh-phone').wrap("<div class='col-phone'></div>");
    $j(cpanel).find('.cfh-email').wrap("<div class='col-email'></div>");
    $j(cpanel).find('.containerPadding>p').wrapAll("<div class='col-hours'></div>");

    $j.each(['phone', 'email'], function (i, val) {
      //console.log($j(cpanel).find('.cfh-' + val));
      //console.log($j(cpanel).find('.cfh-' + val).html());
      var tmp = $j(cpanel).find('.cfh-' + val), parts = $j(tmp).html();
      if (parts) {
        $j(tmp).html(parts);
      }
    });
    panel.removeClass('hidden');
    e.preventDefault();
  });

  $j('.my-applications-link').on('click', function (e) {
    $j('#dropdown-panel')
        .find('.panel-content')
          .html($j('#productPanel').html())
        .end()
        .find('.innerContainer')
          .removeClass('innerContainer')
        .end()
        .removeClass('hidden');
    e.preventDefault();
  });

  $j('.panel-close').on('click', function () {
    $j(this).parent().addClass('hidden').find('.panel-content').html('');
  });

  $j('select').each(function() {
    if (/\*/.test($j(this).find('option:first').text())) {
      if (this.selectedIndex === 0) {
        $j(this).addClass('required');
      }
    }
  }).on('change', function() {
      if (this.selectedIndex === 0) {
        $j(this).addClass('required');
      } else {
        $j(this).removeClass('required');
      }
  });

  /* convert input[type=submit] elements to buttons */
  $j('input[type=submit]').each(function (idx, el) {
    $j(el).replaceWith('<button type="submit" class="' + $j(el).attr('class') + '" id="' + $j(el).attr('id') + '" name="' + $j(el).attr('name') + '">' + $j(el).attr('value') + '</button>');
  });

  /* show server errors */
  if ($j('.server-errors span').text() !== '') {
    var header = $j('.server-errors h4').parent().html(), ulist = $j('.server-errors ul').html();
    if (ulist === undefined) {
      ulist = '';
      header = $j(this).find('.messageCell').text();
    }
    $j('.server-errors span').replaceWith(header + '<ul>' + ulist + '</ul>');
    $j('.server-errors').removeClass('hidden');
  }

  $j(document).keydown(function(e) {
    var element = e.target.nodeName.toLowerCase(), type = $j(e.target).attr('type');
    if ((element !== 'input' || type === 'radio') && element !== 'textarea') {
      if (e.keyCode === 8) {
        return false;
      }
    }
  });
  //$j('body').append( "<div id='loading' style='display:none;position: fixed;top: 50%;left: 50%;''><img src='img/loading.gif' alt='' />Loading please wait....!</div>" );
});

// @mathias
// https://gist.github.com/901295

(function(doc) {
  var n = navigator.userAgent.toLowerCase();
  if (!((/msie/.test(n)) && (!/opera/.test(n)))) {
    var metas = doc.querySelectorAll('meta[name="viewport"]'),
        forEach = [].forEach;
    function fixMetas(isFirstTime) {
      var scales = isFirstTime === true ? ['1.0', '1.0'] : ['0.25', '1.6'];
      forEach.call(metas, function(el) {
        el.content = 'width=device-width,minimum-scale=' + scales[0] + ',maximum-scale=' + scales[1];
      });
    }
    fixMetas(true);
    doc.addEventListener('gesturestart', fixMetas, false);

    // http://stackoverflow.com/questions/7759879/page-shifts-to-the-left-when-rotating-ipad-from-landscape-to-portrait
    if (/iPhone|iPad|iPod/.test(navigator.platform)&&-1<navigator.userAgent.indexOf("AppleWebKit")) {
      window.addEventListener('orientationchange', function() {
        var ua = navigator.userAgent;
        if (window.orientation == 0 || window.orientation == 180) {
          // Reset scroll position if in portrait mode.
          window.scrollTo(0, 0);
        } else if (/OS [7]_[0-9_]* like Mac OS X/i.test(ua)) {
          fixMetas(true);
          doc.addEventListener('gesturestart', fixMetas, false);
          window.scrollTo(0, 0);
        }
      }, false);
    }
  }

}(document));
