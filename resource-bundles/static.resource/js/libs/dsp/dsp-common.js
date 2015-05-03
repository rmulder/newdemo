/*!
 * Common jQuery methods for DSP project
 *
 * Copyright 2014 Terafina Inc
 */
if (window.console === undefined) {
  window.console = {
    log: function(){},
    error: function(){}
  }
}

function _arrayBufferToBase64(buffer) {
    var binary = ''
    var bytes = new Uint8Array( buffer )
    var len = bytes.byteLength;
    for (var i = 0; i < len; i++) {
        binary += String.fromCharCode(bytes[ i ])
    }
    return window.btoa(binary);
}

$j = jQuery.noConflict();
$j(document).ready(function () {
  var schedule_div = null;
  $j('.help-link').on('click', function (e) {
    e.preventDefault();
    $j('#dropdown-panel-help').removeClass('hidden');
    /*
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
    */
  });

  $j('.my-applications-link').on('click', function (e) {
    e.preventDefault();
    $j('#dropdown-panel-products').removeClass('hidden');
/*

    $j('#dropdown-panel')
        .find('.panel-content')
          .html($j('#productPanel').html())
        .end()
        .find('.innerContainer')
          .removeClass('innerContainer')
        .end()
        .removeClass('hidden');
*/
  });

  $j('.schedule-link').on('click', function (e) {
    e.preventDefault();
    DSP.handleScheduleRequest(e);
  });

  $j('.panel-close').on('click', function (e) {
    $j(this).parent().addClass('hidden');
///*
    if (schedule_div != null) {
      //console.log($j(this).parent().find('.panel-content'));
      schedule_div.appendTo('.right-panel');
      schedule_div = null;
      $j(this).parent().addClass('hidden');
    }
//*/
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

  $j('[class*="prefilling_input_fields"]').click(function () {
    (function(d) {
      if (!d) {
        var f = "fill";
        var p = "pate";
      } else {
        var f = "fill" + d;
        var p = "pate" + d;
      }
      var fills = $j('div .' + f);
      var pates = $j('div .' + p);
      if (!fills.length || !pates.length)
        return;
      else {
        if (fills.length == pates.length) {
          for (var i = 0; i < fills.length; i++) {
            $j(fills[i]).children('label').text('');
            $j(fills[i]).children('input').val($j(pates[i]).children('input').val());
          }
          return arguments.callee(++d);
        } else {
          alert("a number of input field set in source and destination has to be matched.");
          return;
        }
      }
    })(0);
  });

  //$j('body').append( "<div id='loading' style='display:none;position: fixed;top: 50%;left: 50%;''><img src='img/loading.gif' alt='' />Loading please wait....!</div>" );
/*
  var maxStringSize = 6000000;    //Maximum String size is 6,000,000 characters
  var maxFileSize = 4350000;      //After Base64 Encoding, this is the max file size
  var chunkSize = 950000;         //Maximum Javascript Remoting message size is 1,000,000 characters
  var attachment;
  var attachmentName;
  var fileSize;
  var positionIndex;
  var doneUploading;

  //Method to prepare a file to be attached to the Promotion bound to the page by the standardController
  window.handleFileChangeEvent = function(e, th, Controller, callback) {
    e.preventDefault();
    e.stopPropagation();
    var $th = $j(th), id = $th.data('id'), file, parentId = $j('#id').val();
    if (this.files) {
      console.log('id:', id);
      file = document.getElementById('file'+id).files[0];
      console.log('$th:', $th, 'id:', id, 'parentId:', parentId, 'file:', file);
      $j('body').css('cursor', 'progress');
      if (file != undefined) {
        if (file.size <= maxFileSize) {
          attachmentName = file.name;
          var fileReader = new FileReader();
          fileReader.onloadend = function(e) {
            attachment = _arrayBufferToBase64(this.result);  //Base 64 encode the file before sending it
            positionIndex=0;
            fileSize = attachment.length;
            console.log("Total Attachment Length: " + fileSize);
            doneUploading = false;
            if (fileSize < maxStringSize) {
              uploadAttachment(parentId, id, null, callback);
            } else {
              alert("Base 64 Encoded file is too large.  Maximum size is " + maxStringSize + " your file is " + fileSize + ".");
            }
          }
          fileReader.onerror = function(e) {
            alert("There was an error reading the file.  Please try again.");
          }
          fileReader.onabort = function(e) {
            alert("There was an error reading the file.  Please try again.");
          }

          fileReader.readAsArrayBuffer(file);  //Read the body of the file
        } else {
          alert("File must be under 4.3 MB in size.  Your file is too large.  Please try again.");
        }
      } else {
        alert("You must choose a file before trying to upload it");
      }
    } else {
      alert('Notice: File upload capability is not available on outdated browsers. Please upgrade to a modern browser (such as: Internet Explorer >= version 10, Firefox, Chrome, Safari) in order to upload files.');
    }
  };

  //Method to send a file to be attached to the (Parent Object) bound to the page by a standardController
  //Sends parameters: parentId Id, Attachment (body), Attachment Name, and the Id of the Attachment if it exists to the controller
  function uploadAttachment(parentId, attachmentNumber, fileId, callback) {
    try {
      var attachmentBody = "";
      if (fileSize <= positionIndex + chunkSize) {
        attachmentBody = attachment.substring(positionIndex);
        doneUploading = true;
      } else {
        attachmentBody = attachment.substring(positionIndex, positionIndex + chunkSize);
      }
      console.log("Uploading " + attachmentBody.length + " chars of " + fileSize);
      //if (size === 'xs' || size === 'sm') {alert("Uploading " + attachmentBody.length + " chars of " + fileSize);}
      //alert("Uploading " + attachmentBody.length + " chars of " + fileSize);
      //alert('parentId:' + parentId + '; attachmentNumber:' + attachmentNumber + '; attachmentName' + attachmentName + '; fileId:' + fileId);
      Controller.uploadAttachment(
          parentId, attachmentNumber, attachmentBody, attachmentName, fileId,
          function(result, event) {
            console.log(result, event);
            if (event.type === 'exception') {
              console.log("exception");
              console.log(event);
            } else if(event.status) {
              if (result.substring(0,3) == '00P') {
                if (doneUploading == true) {
                  //window.open("/"+promoId, "_blank");
                  //window.location.reload();
                  $j('body').css('cursor', 'default');
                  if (typeof callback == 'function') {
                    callback(parentId);
                  }
                  $j('<div class="row col-md-10 alert alert alert-success fade in" role="alert">\
                        <button type="button" class="close" data-dismiss="alert"><span aria-hidden="true">×</span>\
                        <span class="sr-only">Close</span></button>\
                        <strong>Image Uploaded</strong>\
                      </div>').prependTo('#alerts');
                } else {
                  positionIndex += chunkSize;
                  uploadAttachment(parentId, attachmentNumber, result);
                }
              }
            } else {
              console.log(event.message);
            }
          },
          {buffer: true, escape: true, timeout: 120000}
      );
    } catch (e) {
      console.log('error:', e.stack);
      alert('An error has occurred: ' + e.message);
    }
  }
*/
});

(function($) {
  $.fn.serializeObject = function() {
    var self = this,
        json = {},
        push_counters = {},
        patterns = {
          "validate": /^[a-zA-Z][a-zA-Z0-9_]*(?:\[(?:\d*|[a-zA-Z0-9_]+)\])*$/,
          "key":      /[a-zA-Z0-9_]+|(?=\[\])/g,
          "push":     /^$/,
          "fixed":    /^\d+$/,
          "named":    /^[a-zA-Z0-9_]+$/
        };

    this.build = function(base, key, value) {
      base[key] = value;
      return base;
    };

    this.push_counter = function(key) {
      if(push_counters[key] === undefined){
        push_counters[key] = 0;
      }
      return push_counters[key]++;
    };

    $.each($(this).serializeArray(), function() {
      // skip invalid keys
      if(!patterns.validate.test(this.name)){
        return;
      }

      var k,
          keys = this.name.match(patterns.key),
          merge = this.value,
          reverse_key = this.name;

      while ((k = keys.pop()) !== undefined) {
        // adjust reverse_key
        reverse_key = reverse_key.replace(new RegExp("\\[" + k + "\\]$"), '');

        // push
        if (k.match(patterns.push)) {
          merge = self.build([], self.push_counter(reverse_key), merge);
        }

        // fixed
        else if (k.match(patterns.fixed)) {
          merge = self.build([], k, merge);
        }

        // named
        else if (k.match(patterns.named)) {
          merge = self.build({}, k, merge);
        }
      }

      json = $.extend(true, json, merge);
    });

    return json;
  };

  $.fn.fixedNavs = function (settings) {
    return this.each(function () {

      // default css declaration
      var elem = $(this), offset = elem.offset(), left = offset.left;
      //console.log('left starting point:', left, 'for elem:', elem);

      var setWidths = function () {
        elem.css('position', 'relative').css('left', 'inherit').css('margin-left', '');
        offset = elem.offset(), left = offset.left;
      };

      var setPosition = function () {
        elem.css('position', 'fixed').css('left', '').css('margin-left', '');
        var top = 0;
        // get no of pixels hidden above the the window
        var scrollTop = $(window).scrollTop();
        // get elements distance from top of window
        var topBuffer = ((settings.topBoundary || 0) - scrollTop);
        // update position if required
        if (topBuffer >= 0) { top += topBuffer }
        elem.css('left', left).css('margin-left', 0);
        elem.scrollTop(top);
      };

      $(window).bind('scroll', setPosition);
      $(window).bind('resize', setWidths);
      setPosition();
    });
  };
})(jQuery);

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
