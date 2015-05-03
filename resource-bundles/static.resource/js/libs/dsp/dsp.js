/*!
 * jQuery Validation extension for DSP project
 *
 * Copyright 2014 Terafina Inc
 * Released under the MIT license:
 *   http://www.opensource.org/licenses/mit-license.php
 */
(function($) {
  $.extend(true, $.validator, {
    prototype: {
      rules: {
      },
      addCustomValidations: function (fields) {
        $.each(fields, function(index, val) {
          var elms = $('.' + val);
          var custom_options = {
            translation: {
              '9': {pattern: /\d/},
              '0': {pattern: /\d/, optional: true},
              '#': {pattern: /\d/, recursive: true},
              '*': {pattern: /[a-zA-Z0-9]/},
              'S': {pattern: /[a-zA-Z]/}
            }
          };
          $.each(elms, function(i, el) {
            if ($.data(el.form, "validator")) {
              switch (val) {
                case 'firstName':
                  $(el).rules('add', {'rangelength': [1, 15]});
                  break;
                case 'middleName':
                  $(el).rules('add', {'maxlength': 15});
                  break;
                case 'lastName':
                  $(el).rules('add', {'rangelength': [2, 20]});
                  break;
                case 'phoneUS':
                  $(el).mask('(999) 999-9999', custom_options);
                  break;
                case 'durationYears':
                  $(el).rules('add', {integer: true});
                  $(el).rules('add', {maxlength: 2});
                  $(el).rules('add', {min: 0});
                  $(el).rules('add', {max: 99});
                  break;
                case 'durationMonths':
                  $(el).rules('add', {integer: true});
                  $(el).rules('add', {maxlength: 2});
                  $(el).rules('add', {min: 0});
                  $(el).rules('add', {max: 11});
                  break;
                case 'zipcodeUS':
                  $(el).mask('99999', custom_options);
                  break;
                case 'currencyUS':
                  $(el).mask('#,##0', {reverse: true, maxlength: false});
                  break;
                case 'routingNumber':
                  $(el).rules('add', {
                    digits: true,
                    minlength: 9,
                    maxlength: 9,
                    messages: {
                      minlength: "Routing number must be 9 digits"
                    }
                  });

                  //add custom message: Please enter 9 digits
                  $(el).mask('999999999', custom_options);
                  break;
                case 'accountNumber':
                  $(el).rules('add', {digits: true});
                  $(el).rules('add', {maxlength: 16});
                  break;
                case 'ssn':
                  //alert("getting into the date");
                  $(el).mask('***-**-9999', custom_options);
                  break;
                case 'Lastssn':
                  //alert("getting into the last ssn");
                  $(el).mask('9999', custom_options);
                  break;
                case 'year':
                  $(el).mask('9999', custom_options);
                  var d = new Date();
                  $(el).rules('add', {max: d.getFullYear()});
                  $(el).rules('add', {min: d.getFullYear() - 200});
                  break;
                case 'dob':
                case 'date':
                case 'dateUS':
                  //console.log('val:', val, 'el:', el);
                  //$(el).rules('add', {dateUS: true});
                    //alert("getting into the date");
                  $(el).mask('99/99/9999', custom_options);
                  break;
                case 'identityNumber':
                  $(el).rules('add', {alphanumericwithasterisk: true});
                  $(el).rules('add', {maxlength: 15});
                  break;
                case 'einnumber':
                  $(el).rules('add', {digits: true});
                  $(el).rules('add', {maxlength: 9});
                  break;
              }
            }
          });
        });
      }
    }
  });

  $.validator.setDefaults({
    beforeCheckForm: function(form) {
      //RMM: NOTE: This code is very, very important for the validate & FloatLabel plugins to work properly together!!!
      $(form).find('.js-float-label-wrapper input,textarea').trigger({type: 'reset'});
    },
    showErrors: function(errorMap, errorList) {
      // Clean up any tooltips for valid elements
      $.each(this.validElements(), function (index, element) {
        var $element = $(element), type = $element.prop('type'), $el;
        switch (type) {
          case 'radio':
            $el = $element.closest('div.fieldSet');
            break;
          case 'select-one':
            $el = $element.closest('div.styled-select');
            break;
          case 'text':
          default:
              $el = $element;
            break;
        }

        $el.data("title", "") // Clear the title - there is no error associated anymore
            .removeClass("error")
            .addClass("valid")
            .tooltip("destroy")
            .parent().find('div.tooltip').remove();
      });

      // Create new tooltips for invalid elements
      $.each(errorList, function (index, error) {
        var $element = $(error.element), type = $element.prop('type'), $el;
        switch (type) {
          case 'radio':
            $el = $element.closest('div.fieldSet');
            break;
          case 'select-one':
            $el = $element.closest('div.styled-select');
            break;
          case 'text':
          default:
            $el = $element;
            break;
        }
        $el.tooltip("destroy") // Destroy any pre-existing tooltip so we can repopulate with new tooltip content
            .data("title", error.message)
            .removeClass("valid")
            .addClass("error")
            .tooltip(); // Create a new tooltip based on the error message we just set in the title
      });
    }
  });
}(jQuery));
