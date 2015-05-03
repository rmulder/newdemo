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
  'vm',
  'Handlebars',
  'text!templates/layout.html',
  'text!templates/iframe_layout.html'
], function ($, _, Backbone, Vm, hbs, layoutTemplate, ifLayoutTemplate) {
  Backbone.View.prototype.close = function () {
    this.remove();
    this.unbind();
  };

  var AppView = Backbone.View.extend({
    el: '.container-fluid',
    template: hbs.compile(layoutTemplate),

    //intialize function is called automatically
    initialize: function () {
      //console.log('app:initialize()');
      var self = this, data;
      hbs.registerHelper("debug", function (optionalValue) {
        console.log("Current Context");
        console.log("====================");
        console.log(this);

        if (!optionalValue.hash && optionalValue) {
          console.log("Value");
          console.log("====================");
          console.log(optionalValue);
        }
      });

      hbs.registerHelper('parseJSON', function(data, options) {
        return options.fn(JSON.parse(data));
      });

      hbs.registerHelper('render', function(partialId, options) {
        var selector = 'script[type="text/x-handlebars-template"]#' + partialId,
            source = $(selector).html(),
            html = hbs.compile(source)(options.hash);
        console.log('options:', options);

        return new hbs.SafeString(html);
      });

      hbs.registerHelper('raw', function(partialName) {
        return hbs.partials[partialName];
      });

      hbs.registerHelper('formatCurrency', function(value) {
        return (value === undefined)? '' : value.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
      });

      hbs.registerHelper('split', function (str, schar, index) {
        if (arguments.length < 3) {
          throw new Error("Handlebars Helper equal needs 3 parameters");
        }
        if (str === undefined) {
          throw new Error("Specified string not found");
        }
        var sArr = str.split(schar);
        if (sArr[index] === undefined) {
          throw new Error("Specified string index not found");
        } else {
          return sArr[index];
        }
      });

      hbs.registerHelper('equal', function (lvalue, rvalue, options) {
        if (arguments.length < 3) {
          throw new Error("Handlebars Helper equal needs 2 parameters");
        }
        if (lvalue !== rvalue) {
          return options.inverse(this);
        } else {
          return options.fn(this);
        }
      });

      hbs.registerHelper('notequal', function (lvalue, rvalue, options) {
        if (arguments.length < 3) {
          throw new Error("Handlebars Helper equal needs 2 parameters");
        }
        if (lvalue === rvalue) {
          return options.inverse(this);
        } else {
          return options.fn(this);
        }
      });

      hbs.registerHelper('orequal', function (lvalue, rvalue, r2value, options) {
        if (arguments.length < 4) {
          throw new Error("Handlebars Helper equal needs 3 parameters");
        }
        if (lvalue !== rvalue && lvalue !== r2value) {
          return options.inverse(this);
        } else {
          return options.fn(this);
        }
      });

      hbs.registerHelper('compare', function (lvalue, operator, rvalue, options) {
        if (arguments.length < 3) {
          throw new Error("Handlebars Helper 'compare' needs 2 parameters");
        }

        var operators, result;
        if (options === undefined) {
          options = rvalue;
          rvalue = operator;
          operator = "===";
        }

        operators = {
          '==': function (l, r) { return l == r; },
          '===': function (l, r) { return l === r; },
          '!=': function (l, r) { return l != r; },
          '!==': function (l, r) { return l !== r; },
          '<': function (l, r) { return l < r; },
          '>': function (l, r) { return l > r; },
          '<=': function (l, r) { return l <= r; },
          '>=': function (l, r) { return l >= r; },
          'typeof': function (l, r) { return typeof l == r; }
        };

        if (!operators[operator]) {
          throw new Error("Handlebars Helper 'compare' doesn't know the operator " + operator);
        }

        result = operators[operator](lvalue, rvalue);
        if (result) {
          return options.fn(this);
        } else {
          return options.inverse(this);
        }
      });

      hbs.registerHelper('ifCond', function (v1, operator, v2, options) {
        switch (operator) {
          case '==':
            return (v1 == v2) ? options.fn(this) : options.inverse(this);
          case '===':
            return (v1 === v2) ? options.fn(this) : options.inverse(this);
          case '<':
            return (v1 < v2) ? options.fn(this) : options.inverse(this);
          case '<=':
            return (v1 <= v2) ? options.fn(this) : options.inverse(this);
          case '>':
            return (v1 > v2) ? options.fn(this) : options.inverse(this);
          case '>=':
            return (v1 >= v2) ? options.fn(this) : options.inverse(this);
          case '&&':
            return (v1 && v2) ? options.fn(this) : options.inverse(this);
          case '||':
            return (v1 || v2) ? options.fn(this) : options.inverse(this);
          default:
            return options.inverse(this);
        }
      });

      /* Assign to the Global $j (as defined in dsp-common.js) so that processData() will understand $j. */
      $j = $;
      self.render();
    },

    render: function () {
      //console.log('app:render()');
      //Here is where we populate the div having class container with layout.html, el has reference to that div as declared on top
      //template has reference to layout.html as declared on top
      //div with class container comes from index.html
      if (DSP.iframe !== false) {
        this.template = hbs.compile(ifLayoutTemplate)
      }

      DSP.models.config.displayHeaderLogo = (document.location.hash == '' || document.location.hash == '#cross-sell')? true : false;
      $(this.el).html(this.template(DSP.models));
      //DSP.processData(DSP, 'IndexPage');
      $('a img.logo').on('click', function (e) {
        e.preventDefault();
        Backbone.history.navigate("", true);
      });
    }
  });

  return AppView;
});