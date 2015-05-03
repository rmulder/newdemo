/*** author: rmulder@terafinainc.com */
/**
 *
 * -> Defining our dsp app routes
 */
define([
  'jquery',
  'jquery.cookie',
  'underscore',
  'backbone',
  'vm',
  'bootstrap'
], function ($, jqc, _, Backbone, Vm) {
  "use strict";
  var AppRouter = Backbone.Router.extend({
    routes: {},

    initialize: function (options) {
      this.appView = options.appView;
    },

    register: function (route, pageName, path) {
      var self = this, reload = false;
      this.routes[pageName] = route;
      if (typeof DSP.controller !== 'undefined') {
        if (typeof DSP.controller.handleRequest !== 'function') {
          //console.log('method ' + name + ' does not exist!');
          DSP.controller.handleRequest = function (data, pageName, callback) {
            data[DSP.namespace + 'Application__c.test'] = 'called dummy method: ' + pageName;
            var tmpdata = DSP.processData(data, pageName);
            callback.apply(null, [tmpdata, {status: true}]);
          };
        }
      }
      this.route(route, pageName, function () {
        DSP.routeTimerStart = Date.now();
        $('.container-fluid .form-contents').html($('.image-loader').html());
        //console.log('route:', route);
        DSP.models.config.currentPage = pageName;
        var args = arguments;
        require([path], function (module) {
          var options = {pageName: pageName}, parameters = route.match(/[:\*]\w+/g), page;
          // Map the route parameters to options for the View.
          if (parameters) {
            _.each(parameters, function (name, index) {
              options[name.substring(1)] = args[index];
            });
          }

          DSP.analytics(pageName);
          if (pageName === 'PersonalInfoPage' && DSP.currentPage === 'CrossSellPage') {
            //always force a reload of PersonalInfo page - just in case changes were made on CrossSell page!
            //reload = true;
          }
          if (typeof DSP.pages[pageName] !== 'undefined') { reload = true; }
          //RMM: hack to force validation to work properly when revisiting a page - force a reload
          console.log("Time to complete route change: ", Date.now()-DSP.routeTimerStart);
          if (reload) {
            DSP.currentPage = pageName;
            window.location.reload();
          } else {
            DSP.pages[pageName] = Vm.create(self.appView, pageName, module, options);
            //console.log(DSP.models.DisplayedFields);
            DSP.currentPage = pageName;
            //console.log('Router: Current Page:' + DSP.currentPage);
            console.log(DSP.models);
          }
        });
      });
    }
  });

  var initialize = function (options) {
    var router = new AppRouter(options);
    // Default route goes first
    _.each(DSP.routes, function(obj, key) {
      //console.log('key:' + key + '; obj:', obj);
      router.register(obj.url, key, obj.view);
    });
    //console.log('router:', router);
    DSP.AppRouter = router;

    Backbone.history.start();
  };

  return {
    initialize: initialize
  };

});
