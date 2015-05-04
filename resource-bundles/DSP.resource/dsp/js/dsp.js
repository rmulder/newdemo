/*!
 * jQuery Validation extension for DSP project
 *
 * Copyright 2014 Terafina Inc.
 * Released under the MIT license:
 *   http://www.opensource.org/licenses/mit-license.php
 */
(function($) {
  $.extend(true, $.validator, {
    prototype: {
      rules: {
      },
/*
      showErrors: function () {
        var validElements, i, el, tmpList = [], th = this;
        this.defaultShowErrors();
        $('i.error').each(function (i, l) {
          var id = $(l).attr('for'), type = $(document.getElementById(id)).prop('type');
          if (type === undefined) {
            try {
              type = $('input[name="'+id+'"').prop('type');
            } catch (e)  {}
          }
          //console.log('type:', type, ', el:', $(document.getElementById(id)));
          //console.log($(l));
          switch (type) {
            case 'select-one':
              //console.log($('#'+$(l).attr('for')).val());
              var cls = ($(document.getElementById(id)).val() === '') ? 'error' : 'valid';
              //console.log('select-one cls:', cls);
              //console.log('element:', $('#' + id));
              //console.log($(document.getElementById(id)));
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

              //console.log($(l).closest('.styled-select').attr('class'));
              //if (cls === 'error') {
                // make sure it gets added to the errorList!
                //tmpList.push({
                  //message: 'This field is required',
                  //element: document.getElementById(id)
                //});
              //}
              break;
            case 'text':
            default:
              $(l).html('').empty()
                  .closest(document.getElementById(id))
                  .removeClass('error')
                  .removeClass('valid')
                  .addClass(($(l).hasClass('valid')?'valid':'error'));
                if (type === 'radio') {
                  $(l).closest('div.fieldSet').removeClass('error');
                  if ($(l).hasClass('error')) {
                    $(l).closest('div.fieldSet').addClass('error');
                  }
                }
              break;
          }
        });

        validElements = this.validElements();
        if (validElements) {
          $.each(validElements, function (index, element) {
            var $element = $(element), type = $(element).prop('type');
            //console.log('element:', $element);
            //console.log('type:', type);
            switch (type) {
              case 'radio':
                $element.closest('div.fieldSet').removeClass('error');
                break;
              case 'select-one':
                $element.closest('.styled-select').removeClass('error').addClass('valid');
                break;
            }

            $element.data("title", "") // Clear the title - there is no error associated anymore
                .removeClass("error");
            if ($element.tooltip) {
              try {
                $element.tooltip("destroy");
              } catch (e) {
              }
            }
          });
        }

        // Create new tooltips for invalid elements
        //$.extend(this.errorList, tmpList);
        $.each(this.errorList, function (index, error) {
          var $element = $(error.element), field = $element.parent().find('label').html();
          if ($element && field) {
            field = field.replace(/<span\b[^<]*(?:(?!<\/span>)<[^<]*)*<\/span>/gi, " ");
            if ($element.tooltip) {
              try {
                $element.tooltip("destroy"); // Destroy any pre-existing tooltip so we can repopulate with new tooltip content
              } catch (e) {
              }
            }

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
*/
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
                  $(el).mask('***-**-9999', custom_options);
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
                  $(el).mask('99/99/9999', custom_options);
                  break;
                case 'identityNumber':
                  $(el).rules('add', {alphanumeric: true});
                  $(el).rules('add', {maxlength: 15});
                  break;
              }
            }
          });
        });
      }
    }
  });

  $.validator.setDefaults({
    showErrors: function(errorMap, errorList) {
      //console.log('errorMap', errorMap);
      //console.log('errorList', errorList);
      // Clean up any tooltips for valid elements
      $.each(this.validElements(), function (index, element) {
        var $element = $(element), type = $element.prop('type'), $el;
        //console.log('valid:', $element);
        //console.log('valid type:', type);
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
            .tooltip("destroy");
      });

      // Create new tooltips for invalid elements
      $.each(errorList, function (index, error) {
        var $element = $(error.element), type = $element.prop('type'), $el;
        //console.log('error:', type, error);
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
    }/*,
    submitHandler: function(form) {
      //alert("insubmit handler");
      var $form = $(form);
      if ($form.data('submitted') === true) {
        alert('You are attempting to submit the form again.');
        return false; 
      } else {
        //$('#loading').show();
        //alert('Submitting form...');
        $form.data('submitted', true);
        $('body').addClass('ui-icon-loading');
        //alert("form has been sucessfully submitted");
        //$form.find('input:submit').attr("disabled", true);
        //$form.find('button:submit').attr("disabled", true);
        //setTimeout(function(){ form.submit(); }, 3000);
        form.submit();
        return true;
      }
    } */
  });
}(jQuery));
