/**
 * Created by robertm on 11/19/14.
 */
var DSP = DSP || {};
DSP.View = Backbone.View.extend({

  initialize: function(options) {
    _.bindAll(this, 'beforeRender', 'render', 'afterRender');
    var _this = this;
    this.render = _.wrap(this.render, function(render) {
      _this.beforeRender();
      render();
      _this.afterRender();
      return _this;
    });
  },

  beforeRender: function() {
    console.log('beforeRender');
  },

  render: function() {
    return this;
  },

  afterRender: function() {
    console.log('afterRender');
  }
});