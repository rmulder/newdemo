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
  'text!templates/app-retrieval.html'
], function($, _, Backbone, Force, forcetk, hbs, validate, vmethods, floatlabel, dsp, dspc, appTemplate, pageTemplate){

  var AppRetrievalPage = Backbone.View.extend({

    el: '.container-fluid .form-contents',
    eld: '.container-fluid .disclosures',
    form: 'body#app-retrieval form',

    template: hbs.compile(appTemplate),
    templatep: hbs.compile(pageTemplate),
    templated: '',

    submitHandler: function() {
      var view = this, $form = $(this.form);
      $form.validate();
      $form.data("validator").addCustomValidations(['lastName', 'ssn', 'dob', 'dateUS', 'Lastssn']);
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

    initialize: function(options) {
      $.extend(this, options);
      var view = this;
      $("body").css("cursor", "progress");
      DSP.remoteMethod(this.pageName, null, function() {
        $("body").css("cursor", "default");
        view.render();
      });
    },

    render: function () {
      var view = this;
      hbs.registerPartial("form-contents", this.templatep(DSP.models));
      $('body').append('<div id="tmp-content" class="hidden">'+this.templatep(DSP.models)+'</div>');
      hbs.registerPartial("header-contents", $('#tmp-content #header-contents').html());
      hbs.registerPartial("action-panel", $('#tmp-content #action-panel').html());
      this.templated = $('#tmp-content #disclosures').html();
      $("body").attr("id","app-retrieval");
      $(this.el).html(this.template(DSP.models));
      $('.products-list').replaceWith($('#tmp-content #products-list').html());
      //console.log('products-list:', $('#tmp-content #products-list').html());
      $('#tmp-content').remove();
      $('.breadcrumbs_list').remove();
      $("#form-contents").html(view.templatep(DSP.models));
      view.submitHandler();
      DSP.setFieldOptions();
      $('.js-float-label-wrapper').FloatLabel();
      $('.submit_left,.submit_right').addClass('hidden');
      return this;
    }

  });

  return AppRetrievalPage;
});
