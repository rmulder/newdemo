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
  'Handlebars',
  'jquery.validate',
  'jquery.validate.methods',
  'jquery.floatlabel',
  'dsp',
  'dsp.common',
  'text!templates/application.html',
  'text!templates/save-for-later.html'
], function($, _, Backbone, Force, forcetk, hbs, validate, vmethods, floatlabel, dsp, dspc, appTemplate, pageTemplate){

  var SaveForLaterPage = Backbone.View.extend({

    el: '.container-fluid .form-contents',
    eld: '.container-fluid .disclosures',
    form: 'body#save-for-later form',
    modal: '#saveForLaterModal',
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
      $("body").css("cursor", "progress");
      DSP.remoteMethod(this.pageName, null, function(results) {
        view.render();
      });
    },

    render: function () {
      var view = this;
      hbs.registerPartial("form-contents", this.templatep(DSP.models));
      $('body').append('<div id="tmp-content" class="hidden">' + this.templatep(DSP.models) + '</div>');
      hbs.registerPartial("header-contents", $('#tmp-content #header-contents').html());
      hbs.registerPartial("action-panel", $('#tmp-content #action-panel').html());
      this.templated = $('#tmp-content #disclosures').html();
      $('#tmp-content').remove();
      $("body").attr("id", "save-for-later");
      $(this.el).html(this.template(DSP.models));
      $(this.eld).html(this.templated);
      $("#form-contents").html(view.templatep(DSP.models));
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
        $('#save-application-form').validate();
        //console.log('form:', $("form"));
        $("#save-application-form").data("validator")
            .addCustomValidations(['email']);

        $('input[type=checkbox]').each(function () {
          var $th = $(this);
          if ($th.data('value')) {
            $th.attr('checked', 'checked');
          }
        });

        if ($('input[type=checkbox]').is(':checked')) {
          $('#application-saved').hide();
          $('#save-application').hide();
          $('#app-saved').show();
          $('#save').hide();
          $('#saved').hide();
          $('#SavedContinue').show();
          $('#cancel').hide();
          $('#cancel-prompt').hide();  // checked
        } else {
          $('#application-saved').hide();
          $('#save-application').show();
          $('#app-saved').hide();
          $('#save').show();
          $('#saved').hide();
          $('#SavedContinue').hide();
          $('#cancel').hide();
          $('#cancel-prompt').hide();
        }
      });
      $('.saved').click(function(e) {
        $('#application-saved').hide();
        $('#save-application').hide();
        $('#app-saved').show();
        $('#save').hide();
        $('#saved').hide();
        $('#SavedContinue').show();
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
      $('.SavedContinue').click(function(e) {
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
      $('.save').click(function(e) {
        window.isSchedulingDone = $(e.target).parent().hasClass('schedule-button');
        var $form = $(view.form);
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
              if(window.isSchedulingDone) {
                $('.saved-heading').addClass('hidden');
                $('.scheduled-heading').removeClass('hidden');
              }
              $('#application-saved').show();
              $('#save-application').hide();
              $('#app-saved').hide();
              $('#save').hide();
              $('#saved').show();
              $('#SavedContinue').hide();
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
        //console.log('schedule button', window.isScheduled);
      $("body").css("cursor", "default");
      DSP.setFieldOptions();
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

  return SaveForLaterPage;
});