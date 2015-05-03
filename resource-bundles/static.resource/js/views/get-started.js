/**
 * Created by robertm on 12/6/13.
 */
/**
 *
 * -> GetStarted View
 */

//This is the view that is loaded first as specified in router.js
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
  'text!templates/application.html',
  'text!templates/get-started.html',
  'text!templates/disclosures.html'
], function($, _, Backbone, Force, forcetk, bootstrap_datepicker, moment, hbs, validate, vmethods, floatlabel, jquery_datetime, dsp, dspc, appTemplate, pageTemplate, discTemplate){

  var GetStartedPage = Backbone.View.extend({

    el: '.container-fluid .form-contents',
    eld: '.container-fluid .disclosures',
    form: 'body#get-started form',
    login_form: 'body#get-started #login-form',
    form_validator: null,
    login_form_validator: null,

    template: hbs.compile(appTemplate),
    templatep: hbs.compile(pageTemplate),
    templated: hbs.compile(discTemplate),

    //Any events on the page should be declared here
    events:{
    },

    //submitHandler posts the data and takes us to the next page
    submitHandler: function() {
      var view = this, $form = $(this.form), $login_form = $(this.login_form);
      view.form_validator = $form.validate();
      $form.data("validator").addCustomValidations(['firstName', 'lastName', 'phoneUS']);
      $form.data('submitted', false);
      $form.submit(function(e) {
        e.preventDefault();
        if (DSP.currentPage == view.pageName) {
          if ($('.login-fields').hasClass('hidden')) {
            if ($form.data("validator").valid() && $form.data('submitted') !== true) {
              $form.find('input,textarea').trigger('reset');
              DSP.remotePostMethod($(view.form), view.pageName, 'cross-sell'); //remotePostMethod is present in main.js
            }
          } else {
            //console.log('login form validator:', view.login_form_validator);
            view.login_form_validator.resetForm();
            view.login_form_validator.element($('#login__c'));
            view.login_form_validator.element($('#password__c'));
            view.loginSubmit($login_form);
          }
        }
        return false;
      });
    },

    loginSubmit: function($form) {
      var view = this, tmpdata, data;
      if ($form.data("validator").valid() && $form.data('submitted') !== true) {
        $form.find('input,textarea').trigger('reset');
        tmpdata = $form.serializeObject();
        data = {id: DSP.id, "Contact.login__c": tmpdata.login__c, "Contact.password__c": tmpdata.password__c};
        $j('.server-errors').html('').addClass('hidden');
        DSP.controller.userLogin(data, function(results, event) {
          console.log('event', event);
          console.log('Result', results);
          if (event.status) {
            if (results === null) {
              //We did not get a valid response back from the server; assume the id or ut is invalid.
              Backbone.history.navigate("session-expired", true);
              return false;
            } else {
              if (results['server-errors'] || results['debug-server-errors']) {
                //We got errors back from the server. Display them and don't navigate to the next page.
                //alert("Your username or password is incorrect")
                var $modal = $('.wrongLogin-modal');
                $modal.modal();
                DSP.setErrors(results);
                return false;
              } else {
                if (results[DSP.namespace + 'Application__c.application_page__c']) {
                  //If the server specified the next page in the flow, navigate to that page.
                  Backbone.history.navigate(DSP.AppRouter.routes[results[DSP.namespace + 'Application__c.application_page__c']], true);
                }
              }
            }
          } else {
            alert('Error contacting server: ' + event.message);
            console.log(event);
          }
        });
      }
    },

    loginHandler: function() {
      var view = this, $form = $(this.login_form), tmpdata, data;
      view.login_form_validator = $form.validate();
      //console.log('login form:', this.login_form);
      //console.log('login form validator:', this.login_form_validator);
      $form.data('submitted', false);
      $form.submit(function(e) {
        e.preventDefault();
        if (DSP.currentPage == view.pageName) {
          view.loginSubmit($form);
        }
      });

      return false;
    },

    initialize: function(options) {
      //console.log('get-started:initialize()');
      $.extend(this, options);
      var view = this;
      DSP.models.config.displayHeaderLogo = true;
      view.render();
      $("body").css("cursor", "progress");
      DSP.remoteMethod(this.pageName, null, function(results) {
        view.reRender();
        if (DSP.models.Application__c.application_page__c && DSP.models.Application__c.application_page__c !== 'GetStartedPage') {
          var obj = DSP.routes[DSP.models.Application__c.application_page__c];
          try {
            if (typeof obj === 'object') {
              Backbone.history.navigate(obj.url, true);
            }
          } catch (e) {
            console.log(e);
          }
        }
      });
    },

    render: function () {
      //console.log('get-started:render()');
      hbs.registerPartial("form-contents", this.templatep(DSP.models)); // form-contents div is present in layout.html
      $('body').append('<div id="tmp-content" class="hidden">'+this.templatep(DSP.models)+'</div>');
      hbs.registerPartial("header-contents", $('#tmp-content #header-contents').html());
      hbs.registerPartial("action-panel", $('#tmp-content #action-panel').html());
      $('#tmp-content').remove();
      $("body").attr("id","get-started"); //For referring to the form on the page
      $(this.el).html(this.template(DSP.models)); //template is put inside div
      $('#flags-container').addClass('hidden').parent().find('.breadcrumbs_list').addClass('hidden');
      //$('.submit_left').parent().find('a').addClass('hidden');
      //$(this.eld).html(this.templated(DSP.models));
      //console.log('get-started:render():DSP.models:', DSP.models);
      //alert('get-started:render():DSP.models.Application__c.current_channel__c:' + DSP.models.Application__c.current_channel__c);
      //$('.js-float-label-wrapper').FloatLabel();
      return this;
    },

    reRender: function () {
      var view = this, $form = $(this.form);
      //$('body').append('<div id="tmp-content" class="hidden">' + view.templatep(DSP.models) + '</div>');
      //$('.products-list').replaceWith($('#tmp-content #products-list').html());
      //$('#tmp-content').remove();
      //hbs.registerPartial("form-contents", this.templatep(DSP.models)); // form-contents div is present in layout.html
      //$('body').append('<div id="tmp-content" class="hidden">'+this.templatep(DSP.models)+'</div>');
      //hbs.registerPartial("header-contents", $('#tmp-content #header-contents').html());
      //hbs.registerPartial("action-panel", $('#tmp-content #action-panel').html());
      //$('#tmp-content').remove();
      //$("body").attr("id","get-started"); //For referring to the form on the page
      //$(this.el).html(this.template(DSP.models)); //template is put inside div
      //$(this.eld).html(this.templated(DSP.models));

      /*
       var loginConfig = localStorage.getItem('gf_login_config'),
       // Salesforce login URL
       loginURL = loginConfig ? loginConfig.loginURL : 'https://test.salesforce.com/',
       // Salesforce consumer key
       consumerKey = loginConfig ? loginConfig.consumerKey : '3MVG9y6x0357HledFmmKitP_D1Kw1SW0YTpmK_.icZKxZebnHvLydZyWo9dsKWc_zYxeYzAF_RLG1pGtauqA6',
       // Salesforce callback URL
       callbackURL = loginConfig ? loginConfig.callbackURL : 'https://test.salesforce.com/services/oauth2/success',
       // Instantiating forcetk ClientUI
       ftkClientUI = new forcetk.ClientUI(loginURL, consumerKey, callbackURL,
       function forceOAuthUI_successHandler(forcetkClient) { // successCallback
       // Initializing Backbone.Force plugin
       Force.initialize(forcetkClient);

       $.mobile.jqmNavigator.pushView(new MainView({ftkClientUI:ftkClientUI}));
       },

       function forceOAuthUI_errorHandler(error) { // errorCallback
       navigator.notification.alert('Login failed: ' + error.message, null, 'Error');
       });

       // Initiating login process
       ftkClientUI.login();
       */
      view.submitHandler();
      view.loginHandler();
      /* date time picker*/
      DSP.dateTimeDetection();
      $("body").css("cursor", "default");
      $('.schedule-appt button').on('click', function(e) {
        DSP.handleScheduleRequest(e);
      });
      //$('.header_background').css('display','none');
      $("input[type='radio']").change(function () {
        $('.server-errors').html('').addClass('hidden');
        if ($(this).val() === "no") {
          $('.input-fields').removeClass('hidden');
          $('.login-fields').addClass('hidden');
          $('.loginForm').removeClass('loginFormHeight');
          $('.content').addClass('contentHeight');
          $('.get-started').removeClass('hidden');
        } else {
          $('.input-fields').addClass('hidden');
          $('.login-fields').removeClass('hidden');
          $('.loginForm').addClass('loginFormHeight');
          $('.content').removeClass('contentHeight');
          $('.get-started').addClass('hidden');
        }
      });
      DSP.setFieldOptions();
      DSP.setSelectOptions();
      $('.js-float-label-wrapper').FloatLabel();
      //$(this.form).find('input,textarea').trigger('reset');
      $('[data-toggle="popover"]').popover ({trigger: 'hover'});
      return this;
    }
  });
  return GetStartedPage;
});
