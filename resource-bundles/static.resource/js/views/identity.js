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
  'text!templates/application.html',
  'text!templates/identity.html'
], function($, _, Backbone, Force, forcetk, bootstrap_datepicker, moment, hbs, validate, vmethods, floatlabel, jquery_datetime, dsp, dspc, appTemplate, pageTemplate){

  var IdentityPage = Backbone.View.extend({

    el: '.container-fluid .form-contents',
    eld: '.container-fluid .disclosures',
    form: 'body#identity form',

    template: hbs.compile(appTemplate),
    templatep: hbs.compile(pageTemplate),
    templated: '',

    events:{
      'click body#identity #previous': 'prev',
      'keyup .error': 'validateField'
    },

    validateField: function(e) {
      //$(e.currentTarget).valid();
    },

    submitHandler: function() {
      var view = this, $form = $(this.form);
      $form.validate();
      $form.data("validator").addCustomValidations(['ssn', 'identityNumber', 'dob', 'dateUS']);
      $form.data('submitted', false);
      $form.submit(function() {
        if (DSP.currentPage == view.pageName) {
          if ($form.data("validator").valid() && $form.data('submitted') !== true) {
            $form.find('input').trigger('reset');
            DSP.remotePostMethod($j(view.form), view.pageName, 'account-details');
          }
        }
        return false;
      });
    },

    prev: function(e) {
      $(this.form).off();
      alert('called prev from identity');
      DSP.previous(e, this.form, this.pageName);
    },
    //This function is invoked if the value in the dropdown changes
    checkCountryCitizenship: function(obj) {
      if ($(obj).val() == 'US Citizen') {
        $(obj).closest('.row')
            .find('select[name*=country_of_citizenship]')
            .removeClass('required')
            .parent()
            .addClass('hidden');
        $('.country_of_citizenship_help').addClass('hidden');
      } else {
        $(obj).closest('.row')
            .find('select[name*=country_of_citizenship]')
            .addClass('required')
            .parent()
            .removeClass('hidden');
        $('.country_of_citizenship_help').removeClass('hidden');
      }
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
      $('body').append('<div id="tmp-content" class="hidden">'+this.templatep(DSP.models)+'</div>');
      hbs.registerPartial("header-contents", $('#tmp-content #header-contents').html());
      hbs.registerPartial("action-panel", $('#tmp-content #action-panel').html());
      this.templated = $('#tmp-content #disclosures').html();
      $('#tmp-content').remove();
      $("body").attr("id","identity");
      $(this.el).html(this.template(DSP.models));
      $(this.eld).html(this.templated);
      $("#form-contents").html(view.templatep(DSP.models) );
    },

    reRender: function () {
      var view = this, products_list;
      this.renderView();
      $('body').append('<div id="tmp-content" class="hidden">' + view.templatep(DSP.models) + '</div>');
      products_list = $('#tmp-content #products-list').html();
      $('#tmp-content').remove();
      view.submitHandler();
      $('input[type=radio]').each(function() {
        $(this).rules('add', {
          required: true,
          messages: {
            required: "Select an option"
          }
        });
      });
      /* date time picker*/
      DSP.dateTimeDetection();
      $('.member_head').each(function() {
        var val = $(this).data('value');
        if (val) {
          $(this).find('input[type=radio][value="' + $(this).data('value') + '"]').prop('checked', true);
        }
      });
      $('.citizenship-type').each(function() {
        view.checkCountryCitizenship(this);
        $(this).change(function() {
          view.checkCountryCitizenship(this);
        });
      });
      $('.save-for-later').click(function(e) {
        DSP.previous(e, view.form, view.pageName, function() {
          Backbone.history.navigate("save-for-later", true);
        });
      });
      $('.schedule-appt').click(function(e) {
        DSP.previous(e, view.form, view.pageName, function() {
          Backbone.history.navigate("schedule", true);
        });
      });

      $("body").css("cursor", "default");
      DSP.setFieldOptions();
      DSP.setSelectOptions();
      $('.js-float-label-wrapper').FloatLabel();
      $('#previous').attr('href', '#employment');
      DSP.afterRender(view.pageName, products_list);
      return this;
    }

  });

  return IdentityPage;
});
