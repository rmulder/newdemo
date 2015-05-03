/*** author: @rmulder */
/**
 *
 * -> Defining our libraries and initializing our app
 */
if (window.console === undefined) {
  window.console = {
    log: function () {},
    error: function () {}
  };
}

/* Global DSP namespace object for our use in the Application. */
var DSP = DSP || {
  resources_url: '',
  custom_resources_url: '',
  bust: "bust=" + (new Date()).getTime(),
  first: false,
  currentPage: '',
  debug: false,
  preload: false,
  retina: '',
  device: '',
  iframe: false
};
//var size = window.getComputedStyle(document.body,':after').getPropertyValue('content');
//alert('size:' + size);
DSP.retina = window.getComputedStyle(document.getElementsByTagName('html')[0],':before').getPropertyValue('content');
//console.log('retina:' + DSP.retina);
DSP.device = window.getComputedStyle(document.getElementsByTagName('html')[0],':after').getPropertyValue('content');
DSP.device = DSP.device.replace(/\'/gi,'');
//console.log('device:' + DSP.device);

/* DSP.models contains the data returned from the server. */
DSP.models = DSP.models || {};
DSP.models.config = DSP.models.config || {};
DSP.models.config.resources_url = DSP.resources_url;
DSP.models.config.custom_resources_url = DSP.custom_resources_url;
DSP.models.ObjectFields = DSP.models.ObjectFields || {};
DSP.models.Pages = DSP.models.Pages || {};
DSP.models.DefaultLabels = {};
/* DSP.pages allows us to keep track of the various views */
DSP.pages = DSP.pages || {};
DSP.org_short_name = DSP.org_name || 'Terafina';
DSP.org_long_name = DSP.org_name || 'Terafina Inc';
//DSP.namespace = DSP.namespace || 'TF4SF__';
DSP.namespace = DSP.namespace || '';
DSP.routes = {
  GetStartedPage: {url: '*actions', view: 'views/get-started'},
  CrossSellPage: {url: 'cross-sell', view: 'views/cross-sell'},
  PersonalInfoPage: {url: 'personal-info', view: 'views/personal-info'},
  EmploymentPage: {url: 'employment', view: 'views/employment'},
  IdentityPage: {url: 'identity', view: 'views/identity'},
  AccountDetailsPage: {url: 'account-details', view: 'views/account-details'},
  PurchaseDetailsPage: {url: 'purchase-details', view: 'views/purchase-details'},
  PropertyDetailsPage: {url: 'property-details', view: 'views/property-details'},
  DeclarationsPage: {url: 'declarations', view: 'views/declarations'},
  ReviewSubmitPage: {url: 'review-submit', view: 'views/review-submit'},
  ConfirmationPage: {url: 'confirmation', view: 'views/confirmation'},
  VerifyIdentityPage: {url: 'verify-identity', view: 'views/verify-identity'},
  ThankYouPage: {url: 'thank-you', view: 'views/thank-you'},
  StatusPortalPage: {url: 'status-portal', view: 'views/status-portal'},
  SessionExpiredPage: {url: 'session-expired', view: 'views/session-expired'},
  SaveForLaterPage: {url: 'save-for-later', view: 'views/save-for-later'},
  SchedulePage: {url: 'schedule', view: 'views/schedule'},
  AppAbandonedPage: {url: 'app-abandoned', view: 'views/app-abandoned'},
  AppRetrievalPage: {url: 'app-retrieval', view: 'views/app-retrieval'},
  AppStatusPage: {url: 'app-status', view: 'views/app-status'},
  AppSubmittedPage: {url: 'app-submitted', view: 'views/app-submitted'},
  TestPage: {url: 'test', view: 'views/test'}
};

/* Main method used to communicate with the backend server. Sends/receives JSON data. */
DSP.remoteMethod = function (pageName, data, callback) {
  "use strict";
  DSP. remoteMethodTimerStart = Date.now();
  data = data || {}; // if data is not set, set to an empty object.
  if (DSP.debug) {
    console.log('data before remoteMethod call:', data);
  }
  if (DSP.controller !== undefined && typeof DSP.controller.handleRequest === 'function') {
    try {
      $j("body").css("cursor", "progress");
      data.id = DSP.id; //assign application id to the JSON data array
      data.ut = DSP.ut; //assign current session user token to the JSON data array
      if (DSP.retina !== '') {
        data.device_pixel_ratio__c = DSP.retina;
      }
      if (DSP.device != '' && DSP.device.indexOf('/') != -1) {
        var parts = DSP.device.split('/');
        if (parts[0] === 'Laptop') {
          data.device_type__c = DSP.device;
        } else {
          data.device_type__c = parts[0];
          data.device_orientation__c = parts[1];
        }
        //alert(DSP.device);
      }

      if (DSP.debug) {
        data.debug = true; //for debugging purposes only!
      }
      $j('.server-errors').html('').addClass('hidden');
      //console.log('Data sent to ' + pageName + ' method:', data);
      if (!DSP.models.Pages[pageName]) {
        //If we don't yet have this object, initialize it now.
        DSP.models.Pages[pageName] = {};
      }
      if (data.post) {
        DSP.models.Pages[pageName]['post'] = {'dataSent': data, 'dataReceived': '', 'event': ''};
      } else {
        DSP.models.Pages[pageName]['get'] = {'dataSent': data};
      }
      DSP.controller.handleRequest(data, pageName, function (results, event) {
        console.log('remoteMethod results:', results, 'event:', event);
        if (data.post) {
          DSP.models.Pages[pageName]['post'].dataReceived = results;
          DSP.models.Pages[pageName]['post'].event = event;
        } else {
          DSP.models.Pages[pageName]['get'].dataReceived = results;
          DSP.models.Pages[pageName]['get'].event = event;
        }
        if (event.status) {
          if (results === null) {
            /* We did not get a valid response back from the server; assume the id or ut is invalid. */
            Backbone.history.navigate("session-expired", true);
            return false;
          } else {
            if (data.post && (results['server-errors'] || results['debug-server-errors'])) {
              //We got errors back from the server. Display them and don't navigate to a new page.
              DSP.setErrors(results);
              return false;
            } else {
              if (DSP.debug) {
                DSP.setErrors(results);
              }

              if (results[DSP.namespace + 'Application__c.application_status__c']) {
                if (results[DSP.namespace + 'Application__c.application_status__c'] === 'Abandoned') {
                  Backbone.history.navigate("app-abandoned", true);
                }
                if (results[DSP.namespace + 'Application__c.application_status__c'] === 'Submitted' &&
                    (pageName !== 'ConfirmationPage' && pageName !== 'ThankYouPage') || pageName === 'AppRetrievalPage') {
                  if (results['redirect-url']) {
                    window.location.href = results['redirect-url'];
                  } else {
                    Backbone.history.navigate("app-submitted", true);
                  }
                }
              }

              //Process/store the data obtained from the server.
              if (pageName === 'AppRetrievalPage' && results['ut']) {
                DSP.ut = results['ut'];
              }
              DSP.processData(results, pageName);
              if (callback) {
                console.log("Time to complete remoteMethod call: ", Date.now()-DSP.remoteMethodTimerStart);
                //Call any callback method that's been specified.
                callback(results, pageName);
              }
              return true;
            }
          }
        } else {
          alert('Error contacting server: ' + event.message);
          console.log(event);
        }
      });
    } catch (e) {
      console.log('error:', e.stack);
      alert('An error has occurred: ' + e.message);
    }
  } else {
    alert('Method ' + pageName + ' does not exist!');
  }
  return false;
};

/* Method used to post data to the backend server. Calls remoteMethod(). */
DSP.remotePostMethod = function ($form, pageName, nextPage) {
  "use strict";
  DSP.postTimerStart = Date.now();
  var data = $form.serializeObject(), obj, idx, res;
  if (DSP.debug) {
    console.log('serialized data:', data);
  }
  _.each(data, function(value, key) {
    obj = DSP.models.ObjectFields[key] || '';
    if (obj === '') {
      switch(pageName) {
        case 'EmploymentPage':
          obj = DSP.namespace + 'Employment_Information__c';
          break;
        case 'IdentityPage':
          obj = DSP.namespace + 'Identity_Information__c';
          break;
        case 'AccountDetailsPage':
        case 'PurchaseDetailsPage':
        case 'PropertyDetailsPage':
          obj = DSP.namespace + 'About_Account__c';
          break;
        case 'DeclarationsPage':
          obj = DSP.namespace + 'Application2__c';
          break;
      }
    }
    if (pageName === 'CrossSellPage') {
      obj = DSP.namespace + 'Application__c';
    } else if (pageName === 'AccountDetailsPage') {
      obj = DSP.namespace + 'About_Account__c';
    } else if (pageName === 'PersonalInfoPage') {
      obj = DSP.namespace + 'Application__c';
    } else if (pageName === 'AppRetrievalPage') {
      obj = '';
    }

    if (obj !== '') {
      obj += '.';
      delete data[key];
    }

    /*if (DSP.namespace != '') {
      key =  + DSP.namespace.toLowerCase() + '__' + key;
    } */
    idx = obj + key;
    data[idx] = value;
    //console.log('idx:' + idx, 'value:', value);
  });
  data.post = true;
  //console.log('remotePostMethod for: ' + pageName, data);
  res = DSP.remoteMethod(pageName, data, function (results) {
    //If we have specified a callback method, call that instead.
    if (typeof nextPage === 'function') {
      nextPage(results);
    } else {
      console.log('remotePostMethod results:', results);
      if (results['Application__c.application_page__c']) {
        //If the server specified the next page in the flow, navigate to that page.
        console.log("Time to complete post: ", Date.now()-DSP.postTimerStart);
        Backbone.history.navigate(DSP.AppRouter.routes[results['Application__c.application_page__c']], true);
        if (DSP.currentPage === 'AppRetrievalPage') {
          DSP.currentPage = results['Application__c.application_page__c'];
          window.location.reload();
        }
      } else {
        //Otherwise, navigate to the next page in the default flow. (i.e., for local/static usage).
        Backbone.history.navigate(nextPage, true);
      }
    }
  });
  return res;
};

DSP.setErrors = function (results) {
  //We got errors back from the server, so display them.
  $j('.server-errors').html('');
  if (results['server-errors']) {
    $j('.server-errors').append(results['server-errors'].replace(/(?:\r\n|\r|\n)/g, '<br />'));
    $j('.server-errors').removeClass('hidden');
  }
  if (results['debug-server-errors']) {
    $j('.server-errors').append(results['debug-server-errors'].replace(/(?:\r\n|\r|\n)/g, '<br />'));
    $j('.server-errors').removeClass('hidden');
  }
  if (results['server-errors-stack-trace']) {
    $j('.server-errors').append(results['server-errors-stack-trace'].replace(/(?:\r\n|\r|\n)/g, '<br />'));
    $j('.server-errors').removeClass('hidden');
  }
};

DSP.processData = function (data, callee) {
  "use strict";
  //DSP.models.DisplayedFields = {};
  //DSP.models.RequiredFields = {};
  var parts, prefix, old_index;
  if (DSP.namespace !== '' ) {
    //console.log('processData - before:', data);
    $j.each(data, function (index, value) {
      if (index.indexOf(".") !== -1 && index.indexOf(DSP.namespace) === 0) {
        old_index = index;
        parts = index.split('.');
        prefix = parts[0].substr(DSP.namespace.length);
        index = parts[1];
        if (index.indexOf(DSP.namespace.toLowerCase()) === 0) {
          index = index.substr(DSP.namespace.toLowerCase().length);
        }
        //console.log('converting ' + index + ' prefix to:' + prefix + '.' + index);
        //strip this prefix off the model name
        index = prefix + '.' + index;
        delete data[old_index];
      }
      data[index] = value;
    });
    //console.log('processData - after:', data);
  }

  //console.log('DSP.processData called from:', callee, 'data:', data);
  data = DSP.processLocalData(data, callee);
  if (typeof data === 'object') {
    var models = ['Application__c', 'Application2__c',
      'Employment_Information__c', 'Identity_Information__c',
      'About_Account__c', 'Cross_Sell_Logic__c'];
    var skipfields = ['id', 'ut'], field, type, classFields, attr;
    $j.each(data, function (index, value) {
      if ($j.inArray(index, skipfields) === -1) {
        //Assume a default Object of DSP.namespace + 'Application__c'
        //console.log('processData: index:' + index, 'value:' + value);
        prefix = 'Application__c';
        if (index.indexOf(".") !== -1) {
          //The object has been specified; use it as the prefix.
          parts = index.split('.');
          prefix = parts[0];
          index = parts[1];
        }
        if (!DSP.models[prefix]) {
          //If we don't yet have this object, initialize it now.
          DSP.models[prefix] = {};
        }
        //i.e., Application__c.first_name__c = 'Bob'
        DSP.models[prefix][index] = value;
        if (prefix === 'Application__c' && (index === 'type_of_mortgage_loan__c' || index === 'type_of_home_equity__c')) {
          DSP.models[prefix]['mortgage_product'] = 'true';
        }
        if (models.indexOf(prefix) !== -1) {
          if (!DSP.models.ObjectFields[index]) {
            DSP.models.ObjectFields[index] = prefix; //inverted fields list
          }

          field = $j('#' + index);
          if (field !== undefined && field.length > 0) {
            //console.log('index:' + index + '; value:' + value + '; field:', field);
            type = field.get(0).tagName;
            switch (type) {
              case 'TEXTAREA':
              case 'INPUT':
                field.val(value);
                //attr = field.attr('data-value');
                // For some browsers, `attr` is undefined; for others,
                // `attr` is false.  Check for both.
                /*if (typeof attr !== typeof undefined && attr !== false) {
                  field.data('value', value);
                } */
                break;
              case 'SELECT':
                field.data('value', value);
                break;
              default:
                field.html(value);
                break;
            }
            //console.log('#' + index + ' type:', type);
            classFields = $j('.' + index);
            //console.log('class fields:', classFields);
            if (classFields !== undefined && classFields.length > 0) {
              classFields.html(value);
            }
          }
        }
      }
    });
    if (DSP.models.Application__c && DSP.models.Application__c.number_of_products__c) {
      $j('.my-applications-link').removeClass('hidden')
          .find('span').html('(' + DSP.models.Application__c.number_of_products__c + ')');
    }
  }
};

DSP.processLocalData = function (data, callee) {
  "use strict";
  var tmpdata = {};
  //console.log('Callee:' + callee + '; processLocalData:', data);
  if (Storage !== "undefined") {
    //let's use local storage to build up the application data
    if (callee === 'IndexPage') {
      //clear out local storage if first coming to the 'Index' page
      localStorage.clear();
    }
    if (localStorage.data !== undefined) {
      tmpdata = $j.parseJSON(localStorage.data);
    }
  }
/*
  if (tmpdata.RequiredFields) {
    delete tmpdata.RequiredFields;
  }
  if (tmpdata.DisplayedFields) {
    delete tmpdata.DisplayedFields;
  }
*/
  //merge the new data into the existing local storage data
  tmpdata = $j.extend(tmpdata, data);
  if (data.post || callee === 'IndexPage') {
    //if we are coming back from a POST call to the server, or on the Index page - reset the local storage data
    if (Storage !== "undefined") {
      localStorage.data = JSON.stringify(tmpdata);
      console.log('localStorage:', localStorage.data);
    }
  }
  return tmpdata;
};

/* This method handles the 'previous page' functionality */
DSP.previous = function (e, form, pageName, callback) {
  "use strict";
  e.preventDefault();
  e.stopPropagation();
  var $form = $j(form), data = null;
  //Clear out any 'default'/placeholder text first
  $form.find('input,textarea').trigger('reset');
  var data = $form.serializeObject(), obj, idx;
  _.each(data, function(value, key) {
    obj = DSP.models.ObjectFields[key] || '';
    if (obj === '') {
      switch(pageName) {
        case 'EmploymentPage':
          obj = DSP.namespace + 'Employment_Information__c';
          break;
        case 'IdentityPage':
          obj = DSP.namespace + 'Identity_Information__c';
          break;
        case 'AccountDetailsPage':
        case 'PurchaseDetailsPage':
        case 'PropertyDetailsPage':
          obj = DSP.namespace + 'About_Account__c';
          break;
        case 'DeclarationsPage':
          obj = DSP.namespace + 'Application2__c';
          break;
      }
    }
    if (pageName === 'CrossSellPage') {
      obj = DSP.namespace + 'Application__c';
    } else if (pageName === 'AccountDetailsPage') {
      obj = DSP.namespace + 'About_Account__c';
    } else if (pageName === 'AppRetrievalPage') {
      obj = '';
    }

    if (obj !== '') {
      obj += '.';
      delete data[key];
    }
    idx = obj + key;
    data[idx] = value;
    //console.log('idx:' + idx, 'value:', value);
  });

  if (typeof callback === 'function') {
    data.schedule = true;
  } else {
    data.previous = true;
  }
  console.log('previous.data:', data);
  DSP.remoteMethod(pageName, data, function (results) {
    if (typeof callback === 'function') {
      callback(results);
    } else {
      if (results['Application__c.application_page__c']) {
        //If the server specified the previous page in the flow, navigate to that page.
        Backbone.history.navigate(DSP.AppRouter.routes[results[DSP.namespace + 'Application__c.application_page__c']], true);
      } else {
        //Otherwise, navigate to the previous page in the default flow. (i.e., for local/static usage).
        Backbone.history.navigate($j(e.currentTarget).attr('href'), true);
      }
    }
  });
};

DSP.setSelectOptions = function() {
  if (DSP.models.SelectOptions) {
    var exceptions = ['support_phone_number__c'];
    _.each(DSP.models.SelectOptions, function (name, index) {
      //console.log('SelectOption:', name, index);
      if ($j.inArray(index, exceptions) == -1) {
        var $sel =  $j('#' + index), $label, list, i, parts;
        if ($sel.length) {
          list = name.split(';');
          $label = $sel.siblings('label').first();
          $sel.empty().append($j('<option></option>').val('').html($label.text()));
          if (list) {
            //console.log('terms list:', list);
            for (i = 0; i < list.length; i++) {
              parts = list[i].split('_');
              if (parts[0].indexOf('*') === -1) {
                //skip any values which contain '*' - i.e., superflous select option coming back from the server
                $j('<option/>').val(parts[0]).html(parts[1]).appendTo('#' + index);
              }
            }
          }
        }
      }
    });
  }
  $j('select').each(function() {
    var $th = $j(this);
    //console.log('select:', this);
    if ($th.data('value')) {
      $th.find("> [value='" + $th.data('value') + "']").attr("selected", "true").trigger('change');
      $th.closest('.js-float-label-wrapper').addClass('populated');
    }
  });
};

DSP.dateTimeDetection = function() {
  $j('.datepicker1').datetimepicker({
    format:'m/d/Y H:i',
    minDate: 0,
    step:30
  });
  //alert("inside the date detection");
  var size = window.getComputedStyle(document.body,':after').getPropertyValue('content');
  $j('#media-detection').html(size);
  //console.log($j('#media-detection'));
  //alert($j('#media-detection').html());
  //if ($j(window).width() <= 768) {
  if (size === 'xs' || size === 'sm') {
    $j('.datepicker1').attr( "type", "datetime-local" );
  } else {
    $j('.datepicker1').attr( "type", "text" );
  }
};

DSP.handleScheduleRequest = function(e) {
  var view = DSP.pages[DSP.currentPage];
  DSP.previous(e, view.form, view.pageName, function() {
    Backbone.history.navigate("schedule", true);
    //DSP.setSelectOptions();
  });
};

DSP.setFieldOptions = function() {
  $j('input,select,textarea').each(function () {
    var $th = $j(this), id = $th.attr('id'), $sel, $parent, $header, label, name = $th.attr('name'), $label, lab, n,
        exceptions = [
          'login__c',
          'password__c',
          'appointment_location__c',
          'appointment_datetime__c',
          'programDescription',
          'discountPoint',
          'prefill_savings',
          'prefill_certificates'
        ], html;
    if (typeof id != 'undefined' && $j.inArray(id, exceptions) == -1) {
      //console.log('setFieldOptions - name:', name);
      $sel = $j('#' + id), $parent = $sel.closest('.sectionTitleContainer'), $header = $parent.find('.sectionTitle');
      //console.log('$sel:', $sel);
      $label = $sel.closest('.fieldItem').find('label');
      label = DSP.models.DisplayedFields[id];
      if (label) {
        //setup labels here
        //console.log('field ' + id +': label', label);
        lab = $label.text();
        n = lab.indexOf(' *');
        if (n !== -1) {
          lab = lab.substring(0, n);
        }
        if (lab !== label) {
          DSP.models.DefaultLabels[id] = lab;
        }
        $label.html(label);
      } else {
        if (!DSP.models.DisplayedFields[name]) {
          //console.log('will not display field: ' + id, 'object', this);
          $sel.closest('.fieldItem').remove();
          $sel.closest('.fieldSet').remove();
          //console.log('length of parent:', $parent.length);
          //console.log('length of header:', $header.length);
          //console.log('length of fields:', $parent.find('input,select,textarea').length);
          //console.log('remaining section fields:', $parent.find('input,select,textarea'));
          if ($header.length > 0 && $parent.find('input,select,textarea').length === 0) {
            $parent.remove();
          }
        }
      }

      if ($sel.val() != '') {
        $sel.parent('.js-float-label-wrapper').addClass('populated');
      }

      if (DSP.models.RequiredFields[id]) {
        html = $label.html();
        $sel.addClass('required');
        $label.html(html + '<span class="required"> *</span>');
      } else {
        if (!DSP.models.RequiredFields[name]) {
          //console.log('removing required class for: ' + id);
          $sel.removeClass('required');
        }
      }
    }
  });
};

DSP.analytics = function(pageName) {
  var ch = DSP.models.Application__c.current_channel__c || 'Online', src, find = ' ', re = new RegExp(find, 'g'),
      assisted = DSP.models.Application__c.assisted_application__c || 'false', first, utmz = jQuery.cookie('__utmz'),
      location = DSP.location || '';
  ch = ch.replace(re, '');
  src = ch;
  if (assisted !== 'false') {
    src = 'Assisted';
  }
  if (utmz !== undefined) {
    first = utmz.split('.').slice(0,4).join('.');
  } else {
    var a=1,c=0,h,o,d=document.location.host;
    if(d){
      a=0;
      for(h=d["length"]-1;h>=0;h--){
        o=d.charCodeAt(h);
        a=(a<<6&268435455)+o+(o<<14);
        c=a&266338304;
        a=c!=0?a^c>>21:a
      }
    }
    first = a+'.'+new Date().getTime()+'.1.1';
  }

  utmz = first + '.utmcsr=' + src + '|utmccn=online_form_application|utmcmd=' + ch;
  //console.log('utmz:' + utmz);
  jQuery.cookie('__utmz', utmz, {expires: 182, path: '/', domain: '.' + document.location.host});
  //console.log(jQuery.cookie('__utmz'));
  //console.log('channel:' + ch);
  //console.log('location:' + location);
  //console.log('window.performance:', window.performance);
  //alert(window.performance.timing.domComplete- window.performance.timing.navigationStart);
  dataLayer.push({
    'clientName': DSP.orgname || 'Terafina',
    'pageName': pageName,
    'customerId': DSP.customerId || 'None',
    'applicationId': DSP.id,
    'product': DSP.models.Application__c.product__c || '',
    'subProduct': DSP.models.Application__c.sub_product__c || '',
    'formStep': pageName,
    'event': 'pageView',
    'location': ch + ':' + location
  });
  //alert('sent dataLayer!');
};

DSP.afterRender = function(pageName, products_list) {
  var $current = $j('.breadcrumbs_list ul li.item.step-current'), curr_id = $current.prop('id'), parts, currStep,
      $container, $sub_product, header = $j('.header_background'), topBoundary = header.outerHeight();
  //console.log('$current:', $current, 'curr_id:' + curr_id);
  if (curr_id !== undefined && curr_id !== '') {
    $current.find('div').removeClass('hidden');
    parts = curr_id.split('-');
    currStep = parts[1]
    $j('.breadcrumbs_list ul li.item').each(function() {
      var $th = $j(this), id = $th.prop('id'), parts2, tstep;
      //console.log('$th:', $th);
      if (id !== undefined && id !== '') {
        parts2 = id.split('-');
        tstep = parts2[1];
        //console.log('id:', id,'currStep: ' + currStep + '; tstep: ' + tstep, parts2);
        if (tstep < currStep) {
          $th.addClass('step-completed');
        }
      }
    });
  }

  $j('.breadcrumbs_list ul li.item')
    .on('mouseover', function() {
      $current.find('div').addClass('hidden');
      $j(this).find('div').removeClass('hidden');
    }).on('mouseout', function() {
      $j(this).find('div').addClass('hidden');
      $current.find('div').removeClass('hidden');
    });

  if (products_list !== undefined) {
    //console.log('products list:', products_list);
    $container = $j('.productPanel ul');
    $sub_product = $container.find('#sub_product__c');
    $container.html($sub_product).append(products_list);
    //console.log('products:', products_list);
    //console.log('products list:', $j('.productPanel ul'));
  }
  $j('[data-toggle="tooltip"]').tooltip();
  $j('[data-toggle="popover"]').popover ({trigger: 'hover'});
  switch(pageName) {
    case 'GetStartedPage':
    case 'CrossSellPage':
      break;
    default:
      $j('.submit_left').parent().find('a').removeClass('hidden');
      break;
  }
  $j('.submit_left, .submit_right').each(function() {
    $j(this).fixedNavs({topBoundary: topBoundary});
  });
  return this;

};

/* Require.js configuration goes here. */
require.config({
  baseUrl: DSP.resources_url + 'js/',
  paths: {
    // Major libraries
    jquery: 'libs/jquery/jquery.min',
    underscore: 'libs/underscore/underscore-min',
    backbone: 'libs/backbone/backbone-min',
    // Backbone plugin for Salesforce
    'Backbone.Force': 'libs/backbone/backbone.force',
    'backbone.transitions': 'libs/backbone/backbone.responsiveCSS3transitions.min',
    // Salesforce REST API library
    forcetk: 'libs/forcetk/forcetk',
    // Extension Salesforce REST API library providing OAuth UI
    'forcetk.ui': 'libs/forcetk/forcetk.ui',
    // Handle Clean Up Views libraries
    vm: 'libs/vm/vm',
    events: 'libs/vm/events',
    // Bootstrap
    bootstrap: 'libs/bootstrap/bootstrap.min',
    bootstrap_datepicker: 'libs/bootstrap/bootstrap-datepicker',
    // Templating
    Handlebars: 'libs/handlebars/handlebars-min',
    // Auxiliary libraries
    'jquery.floatlabel': 'libs/jquery/jquery.FloatLabel',
    'jquery.mask': 'libs/jquery/jquery.mask',
    'jquery.validate': 'libs/jquery/jquery.validate',
    'jquery.validate.methods': 'libs/jquery/jquery.validate.additional-methods',
    'jquery.cookie': 'libs/jquery/jquery.cookie',
    'jquery.fittext': 'libs/jquery/jquery.fittext',
    dsp: 'libs/dsp/dsp',
    'dsp.common': 'libs/dsp/dsp-common',
    'dsp.view': 'libs/dsp/dsp-view',
    disclosures: 'libs/dsp/disclosures',
    autocomplete: 'libs/dsp/autocomplete.min',
    fields: 'fields',
    nonrequiredfields: 'nonrequiredfields',
    jspdf: 'libs/dsp/jspdf',
    //jquery date time lib
    jquery_datetime: 'libs/jquery/jquery.datetimepicker',
    // JS Date Time lib
    moment: 'libs/moment/moment',
    // Require plugins
    text: 'libs/require/text',
    // Templates
    templates: '../templates'
  },
  shim: {
    'jquery': {
      exports: '$'
    },
    'underscore': {
      exports: '_'
    },
    'backbone': {
      deps: ['underscore', 'jquery'],
      exports: 'Backbone'
    },
    'forcetk': {
      deps: ['jquery'],
      exports: 'forcetk'
    },
    'bootstrap': {
      deps: ['jquery'],
      exports: '$.fn.popover'
    },
    'Handlebars': {
      exports: 'Handlebars'
    },
    'jquery.floatlabel': {
      deps: ['jquery']
    },
    'jquery.mask': {
      deps: ['jquery']
    },
    'jquery.validate': {
      deps: ['jquery']
    },
    'jquery.validate.methods': {
      deps: ['jquery', 'jquery.validate']
    },
    'jquery.cookie': {
      deps: ['jquery']
    },
    'jquery.fittext': {
      deps: ['jquery'],
      exports: '$.fn.fitText'
    },
    'dsp': {
      deps: ['jquery', 'jquery.validate', 'jquery.validate.methods', 'jquery.mask']
    },
    'dsp.common': {
      deps: ['jquery']
    },
    'dsp.view': {
      deps: ['backbone']
    },
    'backbone.transitions': {
      deps: ['backbone'],
      exports: 'backboneResponsiveCSS3Transitions'
    },
    'disclosures': {
      deps: ['jquery']
    },
    'bootstrap_datepicker': {
      deps: ['jquery']
    },
    'moment': {
      deps: ['jquery']
    },
    'jquery_datetime': {
      deps: ['jquery']
    }
  },
  //enforceDefine: true,
  //Set cache buster code: DSP.bust="" for production!!
  urlArgs: DSP.bust || '',
  // 7 is default; 0 disables the timeout
  waitSeconds: 0
});

// Let's kick off the application
//This will take us to app.js
require([
  'views/app',
  'router',
  'vm'
], function (AppView, Router, Vm) {
  "use strict";
  var appView = Vm.create({}, 'AppView', AppView);
  //appView.render();

  Router.initialize({appView: appView});  // The router now has a copy of all main appview
});
