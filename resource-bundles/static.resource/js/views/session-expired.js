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
  'text!templates/session-expired.html'
], function($, _, Backbone, Force, forcetk, hbs, validate, vmethods, floatlabel, dsp, dspc, appTemplate, pageTemplate){

  var SessionExpiredPage = Backbone.View.extend({

    el: '.container-fluid .form-contents',
    eld: '.container-fluid .disclosures',

    template: hbs.compile(pageTemplate),
    templatep: '',
    templated: '',

    events:{
    },

    initialize: function(options) {
      $.extend(this, options);
      this.render();
    },

    render: function () {
      $(this.el).html(this.template(DSP.models));
      $("body").attr("id","session-expired");
      $('.disclosure_text,.tabs-vertical').addClass('hidden');
      $('.breadcrumbs_list').remove();
    }

  });

  return SessionExpiredPage;
});
