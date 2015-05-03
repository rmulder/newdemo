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
        var validElements;
        this.defaultShowErrors();
        $('i.error').each(function (i, l) {
         $(l).html('').empty().append('' );
        });

        validElements = this.validElements();
        if (validElements) {
          $.each(validElements, function (index, element) {
            var $element = $(element);
            //if ($element.tooltip.type) {
              $element.data("title", "") // Clear the title - there is no error associated anymore
                  .removeClass("error")
                  .tooltip("destroy");
            //}
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
            $element.data("title", error.message.replace(/This field/, field))
                .addClass("error")
                .tooltip(); // Create a new tooltip based on the error message we just set in the title
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
      i.attr('class', 'error valid').empty().append('');
    }
  });
}(jQuery));
