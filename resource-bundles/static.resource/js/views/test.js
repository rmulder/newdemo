/*** author: @anotherwebstorm */
/**
 *
 * -> Start App
 */

//Here we load layout.html
define([
  'jquery',
  'underscore',
  'backbone',
  'dsp.view',
  'vm',
  'Handlebars',
  'text!templates/test.html'
], function ($, _, Backbone, dspview, Vm, hbs, template) {

  var TestView = DSP.View.extend({
    el: '.container',
    template: hbs.compile(template),

    //intialize function is called automatically
    initialize: function () {
      this.render();
    },

    render: function () {
      $(this.el).html(this.template());
    }
  });

  return TestView;
});