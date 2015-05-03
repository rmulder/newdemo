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
  'Handlebars',
  'jquery.validate',
  'jquery.validate.methods',
  'jquery.floatlabel',
  'dsp',
  'dsp.common',
  'text!templates/application.html',
  'text!templates/app-status.html'
], function($, _, Backbone, Force, forcetk, bootstrap_datepicker, hbs, validate, vmethods, floatlabel, dsp, dspc, appTemplate, pageTemplate){

  var AppStatusPage = Backbone.View.extend({

    el: '.container-fluid .form-contents',
    eld: '.container-fluid .disclosures',
    form: 'body#app-status form',

    template: hbs.compile(appTemplate),
    templatep: hbs.compile(pageTemplate),
    templated: '',

    events:{
      'click body#app-status #previous': 'prev',
      'keyup .error': 'validateField'
    },

    validateField: function(e) {
      //$(e.currentTarget).valid();
    },

    submitHandler: function() {
      var view = this, $form = $(this.form);
      $form.validate();
      $form.data("validator").addCustomValidations(['lastName', 'ssn', 'dob', 'dateUS', 'Lastssn']);
      $form.data('submitted', false);
      $form.submit(function() {
        console.log('form:', $form);
        if (DSP.currentPage == view.pageName) {
          if ($form.data("validator").valid() && $form.data('submitted') !== true) {
            $form.find('input').trigger('reset');
            DSP.remotePostMethod($j(view.form), view.pageName, function() {
              alert('app-status: callback from submitHandler');
            });
          }
        }
        return false;
      });
    },

    prev: function(e) {
      $(this.form).off();
      DSP.previous(e, this.form, this.pageName);
    },

    initialize: function(options) {
      $.extend(this, options);
      var view = this;
      if (DSP.preload) {
        view.render();
      }
      $("body").css("cursor", "progress");
      DSP.remoteMethod(this.pageName, null, function(results) {
        $("#form-contents").html(view.templatep(DSP.models) );
        view.submitHandler();
        $("body").css("cursor", "default");
      });
    },

    render: function () {
      hbs.registerPartial("form-contents", this.templatep(DSP.models));
      $('body').append('<div id="tmp-content" class="hidden">'+this.templatep(DSP.models)+'</div>');
      hbs.registerPartial("header-contents", $('#tmp-content #header-contents').html());
      hbs.registerPartial("action-panel", $('#tmp-content #action-panel').html());
      //this.templated = $('#tmp-content #disclosures').html();
      $('#tmp-content').remove();
      $("body").attr("id","app-status");
      $(this.el).html(this.template(DSP.models));
      $(this.eld).html(this.templated);
      $('.breadcrumbs_list').remove();
      $('.datepicker').datepicker();
      DSP.setFieldOptions();
      $('.js-float-label-wrapper').FloatLabel();
      return this;
    }

  });

  return AppStatusPage;
});
