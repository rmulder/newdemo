(function( $ ){

	$.fn.FloatLabel = function(options) {

		var defaults = {
			populatedClass : 'populated',
			focusedClass : 'focused'
		},
			settings = $.extend({}, defaults, options);

		return this.each(function() {
			var element = $(this),
				label = element.find('label'),
				input = element.find('textarea, input').not(':disabled'),
        sel = element.find('select').not(':disabled');

      //alert(label.text());
      if (sel.length) {
        sel.closest('.js-float-label-wrapper').addClass('js-float-label-wrapper-select');
        sel.on('change', function() {
          if (sel.val() === ''){
            element.removeClass(settings.populatedClass);
          } else {
            element.addClass(settings.populatedClass);
          }
        });
      }

      if (input.val() === '') {
        input.val(label.text());
      }

			input.on('focus', function() {
				element.addClass(settings.focusedClass);
				if (input.val() === label.text()){
					input.val('');
				} else {
					element.addClass(settings.populatedClass);
				}
			});

      input.on('reset', function() {
        if (input.val() === label.text()){
          //alert('reset called for:' + label.text());
          input.val('');
        }
        element.addClass(settings.populatedClass);
      });

      input.on('blur', function() {
				element.removeClass(settings.focusedClass);
				if (!input.val()) {
					input.val(label.text());
					element.removeClass(settings.populatedClass);
				}
			});

			input.on('keyup', function() {
				element.addClass(settings.populatedClass);
			});
		});
	};
})( jQuery );