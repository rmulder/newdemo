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
  'text!templates/verify-identity.html'
], function($, _, Backbone, Force, forcetk, bootstrap_datepicker, hbs, validate, vmethods, floatlabel, dsp, dspc, appTemplate, pageTemplate){

  var VerifyIdentityPage = Backbone.View.extend({

    el: '.container-fluid .form-contents',
    eld: '.container-fluid .disclosures',
    form: 'body#verify-identity form',

    template: hbs.compile(appTemplate),
    templatep: hbs.compile(pageTemplate),
    templated: '',

    events:{
      'click button[type=submit].myButton': 'submit',
      'click body#verify-identity #previous': 'prev',
    },

    submitHandler: function() {
      var view = this, $form = $(this.form);
      $form.validate();
      $form.data('submitted', false);
      $form.submit(function() {
        if (DSP.currentPage == view.pageName) {
          if ($form.data("validator").valid() && $form.data('submitted') !== true) {
            $form.find('input').trigger('reset');
            DSP.remotePostMethod($j(view.form), view.pageName, 'thank-you');
          }
        }
        return false;
      });
    },

    prev: function(e) {
      $(this.form).off();
      DSP.previous(e, this.form, this.pageName);
    },

    submit: function(e) {
      e.preventDefault();
      DSP.remotePostMethod($(this.form), this.pageName, 'thank-you');
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
      var products_list;
      hbs.registerPartial("form-contents", this.templatep(DSP.models));
      $('body').append('<div id="tmp-content" class="hidden">'+this.templatep(DSP.models)+'</div>');
      hbs.registerPartial("header-contents", $('#tmp-content #header-contents').html());
      hbs.registerPartial("action-panel", $('#tmp-content #action-panel').html());
      this.templated = $('#tmp-content #disclosures').html();
      $("body").attr("id","verify-identity");
      $(this.el).html(this.template(DSP.models));
      $(this.eld).html(this.templated);
      products_list = $('#tmp-content #products-list').html();
      $('#tmp-content').remove();
      $('.datepicker1').datepicker();
      DSP.setFieldOptions();
      DSP.setSelectOptions();
      $('.js-float-label-wrapper').FloatLabel();
      $('#previous').attr('href', '#confirmation');
      DSP.afterRender(view.pageName, products_list);
      return this;
    }

  });

  return VerifyIdentityPage;
});
