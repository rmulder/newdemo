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
  'text!templates/thank-you.html'
], function($, _, Backbone, Force, forcetk, bootstrap_datepicker, hbs, validate, vmethods, floatlabel, dsp, dspc, appTemplate, pageTemplate){

  var ThankYouPage = Backbone.View.extend({

    el: '.container-fluid .form-contents',
    eld: '.container-fluid .disclosures',

    template: hbs.compile(appTemplate),
    templatep: hbs.compile(pageTemplate),
    templated: '',

    events:{
    },

    initialize: function(options) {
      $.extend(this, options);
      var view = this;
      view.render();
/*
     $("body").css("cursor", "progress");
      DSP.remoteMethod(this.pageName, null, function(results) {
        $("#form-contents").html(view.templatep(DSP.models) );
        $("body").css("cursor", "default");
      });
*/
    },

    render: function () {
      hbs.registerPartial("form-contents", this.templatep(DSP.models));
      $('body').append('<div id="tmp-content" class="hidden">'+this.templatep(DSP.models)+'</div>');
      hbs.registerPartial("header-contents", $('#tmp-content #header-contents').html());
      hbs.registerPartial("action-panel", $('#tmp-content #action-panel').html());
      this.templated = $('#tmp-content #disclosures').html();
      $('#tmp-content').remove();
      $("body").attr("id","thank-you");
      $('.datepicker').datepicker();
      $(this.el).html(this.template(DSP.models));
      $(this.eld).html(this.templated);
      $('.breadcrumbs_list').remove();
      $('.submit_left,.submit_right').addClass('hidden');
      $("body").css("cursor", "default");
    }

  });

  return ThankYouPage;
});
