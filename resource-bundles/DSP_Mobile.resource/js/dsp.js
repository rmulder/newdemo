/*!
 * jQuery Validation extension for DSP project
 *
 * Copyright 2013 First Tech Federal Credit Union
 * Released under the MIT license:
 *   http://www.opensource.org/licenses/mit-license.php
 */
(function($) {
  $.extend(true, $.validator, {
    prototype: {
      rules: {
      },
      showErrors: function () {
        var validElements, i, el, tmpList, th = this;
        this.defaultShowErrors();
        $('i.error').each(function (i, l) {
          var id = $(l).attr('for'), type = $(document.getElementById(id)).prop('type');
          //console.log('type:', type, 'el:', $(document.getElementById(id)));
          switch (type) {
            case 'select-one':
              //console.log($('#'+$(l).attr('for')).val());
              var cls = ($(document.getElementById(id)).val() === '') ? 'error' : 'valid';
              //console.log('cls:', cls);
              //console.log('element:', $('#' + id));
              $(document.getElementById(id)).removeClass(th.settings.errorClass);
              //console.log('valid?', $('#' + $(l).attr('for')).valid());
              if (cls === 'valid')  {
                $(l).removeClass('invalid').removeClass('error').addClass('valid');
                //$(l).parent().attr('class', 'error valid');
              }
              $(l).html('').empty()
                  .closest('.styled-select')
                  .removeClass('error')
                  .removeClass('valid')
                  .addClass(cls)
                  .find(document.getElementById(id))
                  .removeClass('error')
                  .removeClass('valid')
                  .addClass(cls);
              break;
            case 'text':
            default:
              $(l).html('').empty()
                  .closest(document.getElementById(id))
                  .removeClass('error')
                  .removeClass('valid')
                  .addClass(($(l).hasClass('valid')?'valid':'error'));
              break;
          }
        });

        validElements = this.validElements();
        if (validElements) {
          $.each(validElements, function (index, element) {
            var $element = $(element);
            $element.data("title", "") // Clear the title - there is no error associated anymore
                .removeClass("error");
            if ($element.tooltip && $element.tooltip.type) {
              $element.tooltip("destroy");
            }
          });
        }

        // Create new tooltips for invalid elements
        $.each(this.errorList, function (index, error) {
          var $element = $(error.element), field = $element.parent().find('label').html();
          if ($element && field) {
            field = field.replace(/<span\b[^<]*(?:(?!<\/span>)<[^<]*)*<\/span>/gi, " ");
            if ($element.tooltip.type) {
              $element.tooltip("destroy"); // Destroy any pre-existing tooltip so we can repopulate with new tooltip content
            }
            //console.log('error element:', $element);
            $element.data("title", error.message.replace(/This field/, field))
              //.addClass("error")
                .closest('.styled-select')
                .addClass('error')
                .end()
                .closest('input[type=text]')
                .addClass('error')
                .end()
                .tooltip() // Create a new tooltip based on the error message we just set in the title
            ;
          }
        });
      },
      addCustomValidations: function (fields) {
        $.each(fields, function(index, val) {
          var elms = $('.' + val);
          $.each(elms, function(i, el) {
            switch (val) {
              case 'firstName':
                $(el).rules('add', {'rangelength': [2, 15]});
                break;
              case 'middleName':
                $(el).rules('add', {'maxlength': 15});
                break;
              case 'lastName':
                $(el).rules('add', {'rangelength': [2, 20]});
                break;
              case 'phoneUS':
                $(el).mask('(999) 999-9999');
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
                $(el).mask('99999');
                break;
              case 'routingNumber':
                $(el).rules('add', {digits: true});
                $(el).mask('9999999999');
                break;
              case 'accountNumber':
                $(el).rules('add', {digits: true});
                $(el).rules('add', {maxlength: 16});
                break;
              case 'ssn':
                $(el).mask('999-99-9999');
                break;
              case 'dob':
              case 'date':
                //console.log('val:', val, 'el:', el);
                //$(el).rules('add', {dateUS: true});
                $(el).mask('99/99/9999');
                break;
              case 'identityNumber':
                $(el).rules('add', {alphanumeric: true});
                $(el).rules('add', {maxlength: 15});
                break;
            }
          });
        });
      }
    }
  });

  $.validator.setDefaults({
    errorElement: "i",
    success: function (i) {
      i.attr('class', 'error valid').empty();
      var id = i.attr('for'), type = $(document.getElementById(id)).prop('type');
      switch (type) {
        case 'select-one':
          i.closest(document.getElementById(id))
              .removeClass('error')
              .addClass('valid');
          break;
        case 'text':
        default:
          i.closest(document.getElementById(id))
              .removeClass('error')
              .addClass('valid');
          break;
      }
    }
  });

}(jQuery));
