/**
 * Created by robertm on 12/6/13.
 */
/**
 *
 * -> PersonalInfo View
 */
define([
  'jquery',
  'underscore',
  'backbone',
  'Backbone.Force',
  'forcetk.ui',
  'bootstrap_datepicker',
  'moment',
  'Handlebars',
  'jquery.validate',
  'jquery.validate.methods',
  'jquery.floatlabel',
  'jquery_datetime',
  'dsp',
  'dsp.common',
  'jspdf',
  'text!templates/application.html',
  'text!templates/review-submit.html'
], function ($, _, Backbone, Force, forcetk, bootstrap_datepicker, moment, hbs, validate, vmethods, floatlabel, jquery_datetime, dsp, dspc, jspdf, appTemplate, pageTemplate) {

  var ReviewSubmitPage = Backbone.View.extend({

    el: '.container-fluid .form-contents',
    eld: '.container-fluid .disclosures',
    form: 'body#review-submit form',

    template: hbs.compile(appTemplate),
    templatep: hbs.compile(pageTemplate),
    templated: '',
    docusignModal: null,
    docusignUrl: null,

    events: {
      'click body#review-submit #previous': 'prev'
    },

    prev: function (e) {
      DSP.previous(e, this.form, this.pageName);
      //console.log("previuos target page", this.pageName);
    },

    handleDocusignEmail: function (view, callback) {
      var $form = $(view.form);
      // for Call Center email to client
      DSP.controller.callDocusign(DSP.id, DSP.models.Application__c.current_channel__c, function (result, event) {
        if (callback) {
          callback(view, $form);
        }
        if (event.status) {
          //good result
        } else {
          alert('problem contacting server' + ' ' + event.message + ' ' + event.where);
        }
      });
    },

    handleDocusignClick: function (view, callback) {
      var height = $(window).height(), iframe, errCount = 0, $form = $(view.form);
      view.docusignModal = $('.docuSign-modal');
      view.docusignModal.modal();
      $('.result').removeClass('hidden');
      $('.close_b').addClass('hidden');
      DSP.controller.callDocusign(DSP.id, DSP.models.Application__c.current_channel__c, function (result, event) {
        console.log('event:', event, 'result:', result);
        if (event.status) {
          // process the result
          //console.log('result:', result);
          if (result['debug-server-errors']) {
            console.log('result:', result);
            $('.fail').removeClass('hidden');
            $('.close_b').removeClass('hidden');
            $('.result').addClass('hidden');
            $('.docusign').removeAttr("disabled").css('opacity', '1');
          } else {
            $('.result').removeClass('hidden');
            iframe = document.getElementById('docusign-frame');
            DSP.receiver = iframe.contentWindow;
            DSP.iframeDoc = iframe.contentDocument || DSP.receiver.document;
            view.docusignUrl = result['docusign-url'];
            $(iframe).attr('src', view.docusignUrl).on('load', function() {
              errCount++;
              console.log('in load callback', $(DSP.iframeDoc));
              try {
                DSP.receiver.postMessage(console.log('innerHTML:', DSP.receiver.document.body.innerHTML), '*');
              } catch(e) {
                console.log('Exception:', e);
                if (errCount > 1) {
                  view.docusignModal.modal('hide');
                  if (callback) {
                    callback(view, $form);
                  }
                }
              }
            });
            $('.success').removeClass('hidden').css('height', height);
            $('.close_b').removeClass('hidden');
            $('.result').addClass('hidden');
            $('.docusign').attr("disabled", "disabled").css('opacity', '0.5');
            view.docusignModal.find(".modal-body").css("max-height", height);
          }
        } else {
          alert('problem contacting server' + ' ' + event.message + ' ' + event.where);
        }
      });
    },

    submitMethod: function (view, $form) {
      var response, $modal = $('#display-submit-modal');
      $form.data('submitted', true);
      $modal.modal();
      DSP.timeout1 = window.setTimeout(function () {
        response = DSP.remotePostMethod($(view.form), view.pageName, function (results) {
          DSP.timeout2 = window.setTimeout(function () {
            $modal.modal('hide');
            if (results[DSP.namespace + 'Application__c.application_page__c']) {
              Backbone.history.navigate(DSP.AppRouter.routes[results[DSP.namespace + 'Application__c.application_page__c']], true);
            } else {
              Backbone.history.navigate('confirmation', true);
            }
          }, 1000);
        });
        if (!response) {
          $form.data('submitted', false);
        }
      }, 1000);
      DSP.timeout3 = window.setTimeout(function () {
        $modal.modal('hide');
        Backbone.history.navigate('confirmation', true);
      }, 100000);
      //return true;
    },

    submitHandler: function () {
      var view = this, $form = $(this.form);
      $form.validate();
      $form.data("validator").addCustomValidations(['durationYears', 'durationMonths', 'currencyUS']);
      $form.data('submitted', false);
      $form.submit(function () {
        if (DSP.currentPage == view.pageName) {
          if ($form.data('previous') !== true) {
            if ($form.data('submitted') === true) {
              alert('This form has already been submitted. Please wait...');
              return false;
            } else {
              if (DSP.models.Application_Configuration__c.docusign_package_installed__c === true && DSP.models.Application__c.current_channel__c !== 'Branch') {
                console.log('in the if method of submithandler',DSP.models.Application_Configuration__c.docusign_package_installed__c );
                if (DSP.models.Application__c.current_channel__c === 'Online') {
                  view.handleDocusignClick(view, view.submitMethod);
                } else {
                  //call docusign email process, then submit
                  view.handleDocusignEmail(view, view.submitMethod);
                }
              } else {
                view.submitMethod(view, $form);
              }
            }
          }
          return false;
        }
      });
    },

    submit: function (e) {
      e.preventDefault();
      console.log('data:', $('form').serialize());
      Backbone.history.navigate("confirmation", true);
    },

    initialize: function (options) {
      $.extend(this, options);
      var view = this;
      $("body").css("cursor", "progress");
      DSP.remoteMethod(this.pageName, null, function (results) {
        view.render();
      });
    },

    print: function () {
      alert('hello!');
    },

    getPdf: function (inline, url) {
      if (!url) url = document.location.href;
      var param = {
        'url': url,
        'plain': '1',
        'filename': (!inline) ? url.replace(/[^a-z|0-9|-|_]/ig, '_').replace(/_{2,}/g, '_') + '.pdf' : ''
      };
      var temp = [];
      for (var key in param)
        temp.push(encodeURIComponent(key) + '=' + encodeURIComponent(param[key]));
      document.location.href = 'http://online.htmltopdf.de/?' + temp.join('&');
    },

    render: function () {
      var view = this, products_list;
      hbs.registerPartial("form-contents", this.templatep(DSP.models));
      $('body').append('<div id="tmp-content" class="hidden">' + this.templatep(DSP.models) + '</div>');
      hbs.registerPartial("header-contents", $('#tmp-content #header-contents').html());
      hbs.registerPartial("action-panel", $('#tmp-content #action-panel').html());
      this.templated = $('#tmp-content #disclosures').html();
      $("body").attr("id", "review-submit");
      $(this.el).html(this.template(DSP.models));
      $(this.eld).html(this.templated);
      products_list = $('#tmp-content #products-list').html();
      $('#tmp-content').remove();
      /* date time picker*/
      DSP.dateTimeDetection();
      $('.icon-print').tooltip();
      $('a').click(function () {
        var checkbox = $(this).prev('input[type="checkbox"]');
        checkbox.attr('checked', checkbox.is(':checked'));
      });

      $('.nextStep').text('Submit');

      if ($('input[type=checkbox]:checked').length != $('input[type=checkbox]').length) {
        $('.submit-button').css('opacity', 0.5).attr('disabled', 'true');
        $(".remove_link_next").removeAttr('href');
        $('.alert-text').removeClass("hidden");

      }
      $("input[type=checkbox]").change(function () {
        if ($('input[type=checkbox]:checked').length == $('input[type=checkbox]').length) {
          $(".remove_link_next").attr("href", "confirmation.html");
          $('.submit-button').removeAttr('disabled').css('opacity', 1);
          $('.alert-text').addClass("hidden");
        } else {
          $('.alert-text').removeClass("hidden");
          $('.submit-button').css('opacity', 0.5).attr('disabled', 'true');
          $(".remove_link_next").removeAttr('href');
        }
      });

      $(".disclosure_1,.disclosure_2,.disclosure_3,.disclosure_4,.disclosure5").attr('disabled', true);
      $('a[class*=enable_check_]').each(function () {
        var $th = $(this), parts = $th.attr('class').split('_');
        if ($('.disclosure_' + parts[2]).data('value')) {
          $('.disclosure_' + parts[2]).attr('disabled', false).trigger('click');
        }
        $th.on('click', function () {
          $('.disclosure_' + parts[2]).attr('disabled', false);
        });
      });

      /* For testing purposes ONLY! */
      //$('a[class*=enable_check]').trigger('click');
      //$('input[class*=disclosure]').trigger('click');

      $('.disclosure_text>a').on('click', function (e) {
        var $th = $(this), height = $(window).height()*0.7, $modal = $('#disclosureModal'),
            el = $th.parent().parent().find('input').attr('class');
        $('#disclosure-frame').attr('src', $th.data('href'));
        $('.disclosure-content').css('height', height);
        $modal.find(".modal-body").css("max-height", height);
        $('#disclosureModalLabel').text($th.text());
        $modal.find('.btn-primary').val(el);

        e.preventDefault();
      });

      $('#disclosureModal .btn-primary').on('click', function() {
        $('.' + $(this).val()).trigger('click');
        return true;
      });

      $('.print-button').click(function () {
        window.print();
        return false;
      });

      $('.previous-button').on('click', function () {
        $('form').data('previous', true).submit();
      });

      view.submitHandler();
      $('.save-for-later').click(function (e) {
        DSP.previous(e, view.form, view.pageName, function() {
          Backbone.history.navigate("save-for-later", true);
        });
      });
      $('.schedule-appt').click(function (e) {
        DSP.previous(e, view.form, view.pageName, function () {
          Backbone.history.navigate("schedule", true);
        });
      });

      //handle the click event for the 'Print All Disclosures' button
      $('#btnPrint').click(function () {
        //open a new popup window
        window.thePopup = window.open('', "PrintAll", "menubar=0,location=0,height=700,width=700");
        //find all of the disclosure checkboxes listed above and iterate through them
        $('#DisclosuresPrimary .disclosure_text>a').each(function () {
          //if there is an href link...
          if ($(this).attr('href')) {
            //add a new embed object within the popup window
            $('<embed width="100%" height="100%" name="plugin" src="' + $(this).attr('href') + '" type="application/pdf">').appendTo(thePopup.document.body);
          }
        });
        //now, enable all of the checkboxes on the page...
        $('a[class*=enable_check_]').each(function () {
          var $th = $(this), parts = $th.attr('class').split('_');
          $('.disclosure_' + parts[2]).attr('disabled', false);
        });
        //trigger a 'click' event for each of the disclosures
        $('input[class*=disclosure]').trigger('click');
        //focus the popup window
        thePopup.focus();
        //create a script tag that loads in jQuery and executes a print() and close() method on the popup
        var scr = $('<script src="' + DSP.resources_url + 'libs/jquery/jquery.min.js"></script><script>jQuery(function() {thePopup.print();thePopup.close();});</script>');
        //append the script to the page and let it automatically run
        scr.appendTo(thePopup.document.body);
      });

      $('.docusign').click(function () {
        view.handleDocusignClick(view);
      });

      $('#toPDF').click(function (e) {
        e.preventDefault();
        var doc = new jsPDF('p', 'pt', 'letter'), source = $("#formContainer")[0],
            specialElementHandlers = {
              '#actionPanel': function (element, renderer) {
                return true;
              }
            };
        window.$ = $;
        doc.fromHTML(source, 15, 15, {'width': 180, 'elementHandlers': specialElementHandlers });
        doc.output("dataurlnewwindow");
        //view.getPdf();
      });

      $("body").css("cursor", "default");
      DSP.setFieldOptions();
      DSP.setSelectOptions();
      $('.js-float-label-wrapper').FloatLabel();
      DSP.afterRender(view.pageName, products_list);
      return this;
    }

  });

  return ReviewSubmitPage;
});
