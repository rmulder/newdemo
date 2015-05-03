/**
 * Created by amardeepmann on 7/31/14.
 */

define([
  'jquery',
  'underscore',
  'backbone',
  'Backbone.Force',
  'forcetk.ui',
  'Handlebars',
  'jquery.validate',
  'jquery.validate.methods',
  'jquery.floatlabel',
  'dsp',
  'dsp.common',
  'jquery_datetime',
  'text!templates/application.html',
  'text!templates/schedule.html'
], function($, _, Backbone, Force, forcetk, hbs, validate, vmethods, floatlabel, dsp, dspc, jquery_datetime, appTemplate, pageTemplate){

  var SchedulePage = Backbone.View.extend({

    el: '.container-fluid .form-contents',
    eld: '.container-fluid .disclosures',
    form: 'body#schedule form',
    modal: '#scheduleModal',
    template: hbs.compile(appTemplate),
    templatep: hbs.compile(pageTemplate),
    templated: '',
    nextpage: '',
    events:{
      'hidden':        'hidden',
      'shown':         'shown'
    },
    submitHandler: function () {
      var view = this, $form = $(this.form);
      $form.validate();
      $form.data("validator").addCustomValidations(['ssn', 'lastName', 'dob', 'dateUS']);
    },

    initialize: function(options) {
      $.extend(this, options);
      var view = this;
      if (DSP.preload) {
        view.render();
      }
      $("body").css("cursor", "progress");
      DSP.remoteMethod(this.pageName, null, function(results) {
        view.reRender();
        $("body").css("cursor", "default");
      });
    },

    render: function () {
      this.renderView();
      $('.js-float-label-wrapper').FloatLabel();
      return this;
    },

    renderView: function () {
      var view = this;
      hbs.registerPartial("form-contents", this.templatep(DSP.models));
      $('body').append('<div id="tmp-content" class="hidden">' + this.templatep(DSP.models) + '</div>');
      hbs.registerPartial("header-contents", $('#tmp-content #header-contents').html());
      hbs.registerPartial("action-panel", $('#tmp-content #action-panel').html());
      this.templated = $('#tmp-content #disclosures').html();
      $('#tmp-content').remove();
      $("body").attr("id", "schedule");
      $(this.el).html(this.template(DSP.models));
      $(this.eld).html(this.templated);
      $('.breadcrumbs_list').remove();
      $("#form-contents").html(view.templatep(DSP.models));
    },

    reRender: function () {
      var view = this;
      this.renderView();
      view.submitHandler();
      $(view.modal).modal({'keyboard': true, 'backdrop': 'static'});
      view.delegateEvents();
      $(document).ready(function () {
        var custom_options = {
          translation: {
            '9': {pattern: /\d/},
            '0': {pattern: /\d/, optional: true},
            '#': {pattern: /\d/, recursive: true},
            '*': {pattern: /[a-zA-Z0-9]/},
            'S': {pattern: /[a-zA-Z]/}
          }
        };
        $(".ssn").mask('***-**-9999', custom_options);
        $(".dob").mask('99/99/9999', custom_options);
        $('.alert-text').hide();
        $('#schedule-appt-form').validate();
        //console.log('form:', $("form"));
        $("#schedule-appt-form").data("validator")
            .addCustomValidations(['email']);

        $('input[type=checkbox]').each(function () {
          var $th = $(this);
          if ($th.data('value')) {
            $th.attr('checked', 'checked');
          }
        });

        if ($('input[type=checkbox]').is(':checked')) {
          $('#appt-scheduled').hide();
          $('#schedule-appointment').hide();
          $('#appt-saved').show();
          $('#save').hide();
          $('#scheduled').hide();
          $('#scheduledContinue').show();
          $('#cancel').hide();
          $('#cancel-prompt').hide();  // checked
        } else {
          $('#appt-scheduled').hide();
          $('#schedule-appointment').show();
          $('#appt-saved').hide();
          $('#save').show();
          $('#scheduled').hide();
          $('#scheduledContinue').hide();
          $('#cancel').hide();
          $('#cancel-prompt').hide();
        }
      });
      $('.scheduled').click(function(e) {
        $('#appt-scheduled').hide();
        $('#schedule-appointment').hide();
        $('#appt-saved').show();
        $('#save').hide();
        $('#scheduled').hide();
        $('#scheduledContinue').show();
        $('#cancel').hide();
        $('#cancel-prompt').hide();
        $(view.modal).modal('hide');
        //alert(this.nextpage);
        if (view.nextpage === '' && DSP.models.Application__c && DSP.models.Application__c.application_page__c) {
          // alert(DSP.models.Application__c.application_page__c);
          view.nextpage = DSP.models.Application__c.application_page__c;
          console.log(DSP.AppRouter.routes[view.nextpage]);
          Backbone.history.navigate(DSP.AppRouter.routes[view.nextpage]);
          window.location.reload();
        } else {
          window.history.back();
        }
      });
      $('.scheduledContinue').click(function(e) {
        //alert("saved continue posting method");
        DSP.remotePostMethod($(view.form), view.pageName, function (results) {
          $(view.modal).modal('hide');
          //console.log('results:', results);
          DSP.processData(results, view.pageName);
          if (results[DSP.namespace + 'Application__c.application_page__c']) {
            //alert(results['Application__c.application_page__c']);
            Backbone.history.navigate(DSP.AppRouter.routes[results[DSP.namespace + 'Application__c.application_page__c']], true);
            window.location.reload();
          } else {
            //Backbone.history.navigate('', true);
            window.history.back();
          }
        });
      });
      $('.close, .cancel').click(function(e) {
        //alert("into the hide functionality");
        e.preventDefault();
        // $(this.modal).modal(true).hide();
        $(view.modal).modal('hide');
        //alert(this.nextpage);
        $("body").css("cursor", "progress");
        if(view.nextpage === '' && DSP.models.Application__c && DSP.models.Application__c.application_page__c){
          // alert(DSP.models.Application__c.application_page__c);
          view.nextpage = DSP.models.Application__c.application_page__c;
          console.log(DSP.AppRouter.routes[view.nextpage]);
          Backbone.history.navigate(DSP.AppRouter.routes[view.nextpage]);
          window.location.reload();
        } else {
          //Backbone.history.navigate(DSP.AppRouter.routes[results['Application__c.application_page__c']], true);
          window.history.back();
        }
      });
      $('.schedule').click(function(e) {
        var $form = $(view.form);
        console.log('form:', $form);
        $form.validate();
        e.preventDefault();
        if (DSP.currentPage == view.pageName) {
          console.log($form.data("validator"));
          //alert($form.data("validator").valid());
          if ($form.data("validator").valid() && $form.data('submitted') !== true) {
            $form.find('input').trigger('reset');
            DSP.remotePostMethod($(view.form), view.pageName, function (results) {
              $form.data('submitted', true);
              console.log('results:', results);
              DSP.processData(results, view.pageName);
              if (results[DSP.namespace + 'Application__c.application_page__c']) {
                /*Backbone.history.navigate(DSP.AppRouter.routes[results['Application__c.application_page__c']], true);*/
                view.nextpage = results[DSP.namespace + 'Application__c.application_page__c'];
              } else {
                //Backbone.history.navigate('', true);
                // window.history.back();
              }
              $('#appt-scheduled').show();
              $('#schedule-appointment').hide();
              $('#appt-saved').hide();
              $('#save').hide();
              $('#scheduled').show();
              $('#scheduledContinue').hide();
              $('#cancel').hide();
              $('#cancel-prompt').hide();
            });
          }
        }
      });
      $('.come-back-later').click(function(e) {
        e.preventDefault();
        var data = {id: DSP.id}, url = $(this).data('href');
        DSP.controller.expireSession(data, function (results, event) {
          console.log('event:', event);
          if (event.status) {
            if (results === null) {
              alert('no response from server');
            } else {
              window.location.href = url;
            }
          } else {
            alert('could not contact server');
          }
        });
      });
      $(view.modal).modal({'show': true});
      var location_div = null, date_div;
      var $form = $(view.form);
      /*
      if (DSP.device.indexOf('Tablet') != -1 || DSP.device.indexOf('Phone') != -1) {
        location_div = $j('.location').detach();
        location_div.find('.fieldItem').removeClass('col-xs-12').addClass('col-xs-7')
            .find('.styled-select').removeClass('background_white');
        location_div.prependTo($('.form-div'));
        date_div = $j('.schedule_date').detach();
        date_div.removeClass('col-xs-12').addClass('col-xs-7');
        date_div.find('.fieldItem').removeClass('margin_right_95').addClass('marginTop20').addClass('col-xs-7');
        date_div.appendTo(location_div);
      } */
      DSP.dateTimeDetection();
      $('.datepicker1').attr("type","text");
      //*/
      $("body").css("cursor", "default");
      DSP.setFieldOptions();
      DSP.setSelectOptions();
      $('.js-float-label-wrapper').FloatLabel();
      return this;
    },

    hidden: function() {
      this.remove();
      return false;
    },

    shown: function() {
      //this.App.Helpers.Forms.setFocus($(this.modal), true);
      return false;
    }
  });

  return SchedulePage;
});