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
  'text!templates/status-portal.html'
], function($, _, Backbone, Force, forcetk, hbs, validate, vmethods, floatlabel, dsp, dspc, appTemplate, pageTemplate){

  var StatusPortalPage = Backbone.View.extend({

    el: '.container-fluid .form-contents',
    eld: '.container-fluid .disclosures',
    form: 'body#status-portal form',

    template: hbs.compile(appTemplate),
    templatep: hbs.compile(pageTemplate),
    templated: '',

    events:{
      'click button[type=submit].myButton': 'submit'
    },

    submit: function(e) {
      e.preventDefault();
      //console.log('data:', $('form').serialize());
      //Backbone.history.navigate("thank-you", true);
    },

    initialize: function(options) {
      $.extend(this, options);
      var view = this;
      view.render();
      $("body").css("cursor", "progress");
      DSP.remoteMethod(this.pageName, null, function(results) {
        $("#form-contents").html(view.templatep(DSP.models) );
        $("body").css("cursor", "default");
      });
    },

    render: function () {
      hbs.registerPartial("form-contents", this.templatep(DSP.models));
      $('body').append('<div id="tmp-content" class="hidden">'+this.templatep(DSP.models)+'</div>');
      hbs.registerPartial("header-contents", $('#tmp-content #header-contents').html());
      hbs.registerPartial("action-panel", $('#tmp-content #action-panel').html());
      this.templated = $('#tmp-content #disclosures').html();
      $('#tmp-content').remove();
      $("body").attr("id","status-portal");
      $(this.el).html(this.template(DSP.models));
      $(this.eld).html(this.templated);
      $('.breadcrumbs_list').remove();
    }

  });

  return StatusPortalPage;
});
