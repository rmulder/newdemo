/**
 * Created by robertm on 12/6/13.
 */
/**
 *
 * -> CrossSell View
 */
define([
  'jquery',
  'underscore',
  'backbone',
  'Backbone.Force',
  'forcetk.ui',
  'bootstrap_datepicker',
  'moment',
  'Handlebars',
  'jquery.validate',
  'jquery.validate.methods',
  'jquery.floatlabel',
  'jquery_datetime',
  'dsp',
  'dsp.common',
  'text!templates/application.html',
  'text!templates/cross-sell.html'
], function ($, _, Backbone, Force, forcetk, bootstrap_datepicker, moment, hbs, validate, vmethods, floatlabel, jquery_datetime, dsp, dspc, appTemplate, pageTemplate) {

  var CrossSellPage = Backbone.View.extend({

    el: '.container-fluid .form-contents',
    eld: '.container-fluid .disclosures',
    form: 'body#cross-sell form',

    template: hbs.compile(appTemplate),
    templatep: hbs.compile(pageTemplate),
    templated: '',

    events: {
      'click .btn-slide': 'slide',
      'click .apDiv1': 'add_crosssell', //event to add additional accounts
      'click input[type="checkbox"]': 'hide_crosssell'
      //'click #continue-btn':'submitHandler'
    },

    products: {},
    channel: '',

    //function to add account on click of +ADD div
    submitHandler: function () {
      var view = this, $form = $(this.form);
      $form.validate();
      $form.data('submitted', false);
      $form.submit(function () {
        if (DSP.currentPage == view.pageName && $form.data("validator").valid()) {
          console.log('Current page', DSP.currentPage);
          DSP.remotePostMethod($(view.form), view.pageName, function (results) {
            $('.my-applications-link').find('span').html('(' + DSP.models.Application__c.number_of_products__c + ')');
            if (results[DSP.namespace + 'Application__c.application_page__c']) {
              //If the server specified the next page in the flow, navigate to that page.
              Backbone.history.navigate(DSP.AppRouter.routes[results[DSP.namespace + 'Application__c.application_page__c']], true);
            } else if ($form.data("validator").valid() && $form.data('submitted') !== true) {
              //Otherwise, navigate to the next page in the default flow. (i.e., for local/static usage).
              Backbone.history.navigate('personal-info', true);
            }
          });
        }
        return false;
      });
    },
    clickCrosssellItem: function (obj) {
      var div = $(obj).data('link');
      $('#' + div).removeClass('hidden');
      $('#' + div).find('input[type="checkbox"]').prop('checked', true);
      $(obj).addClass('hidden');
      $(obj).parent().find(".apDiv2").removeClass('hidden');
      $('#' + div + '_list')
          .removeClass('hidden')
          .siblings()
          .removeClass('lastRow')
          .end()
          .addClass('lastRow');
    },

    add_crosssell: function (e) {
      this.clickCrosssellItem($(e.currentTarget));
    },

    hide_crosssell: function (e) {
      var view = this;
      if (DSP.currentPage == this.pageName) {
        var div = $(e.currentTarget).parent().parent().attr('id'),
            th = $('.product').find('[data-link="' + div + '"]');
        $(th).parent().find('.apDiv2').addClass('hidden');
        $(th).removeClass('hidden');
        $('#' + div).addClass('hidden');
        if (view.channel !== 'Online') {
          var crossNum = div.substring(2);
          $('.cross-select_' + crossNum).find("option[value=' ']").attr("selected", "true").end().val(' ').trigger('change');
        }
        $('#' + div + '_list')
            .removeClass('lastRow')
            .addClass('hidden');
      }
    },

    slide: function (e) {
      $(e.currentTarget).parent().parent().find(".panel").slideToggle("fast");
      $(e.currentTarget).toggleClass("active");
      return false;
    },

    initialize: function (options) {
      $.extend(this, options);
      var view = this;
      DSP.models.config.displayHeaderLogo = true;
      view.render();
      $("body").css("cursor", "progress");
      DSP.remoteMethod(this.pageName, null, function () {
        view.reRender();
        $("body").css("cursor", "default");
        /*
        $(document).ready(function() {
          $.post('write.php', { dom: $('html').html() });
        });
        */
      });
    },

    render: function () {
      var view = this;
      hbs.registerPartial("form-contents", view.templatep(DSP.models));
      $('body').append('<div id="tmp-content" class="hidden">' + view.templatep(DSP.models) + '</div>');
      hbs.registerPartial("header-contents", $('#tmp-content #header-contents').html());
      hbs.registerPartial("action-panel", $('#tmp-content #action-panel').html());
      view.templated = $('#tmp-content #disclosures').html();
      $('#tmp-content').remove();
      $("body").attr("id", "cross-sell");
      $(view.el).html(view.template(DSP.models));
      $(view.eld).html(view.templated);
      $("#cs1").addClass('hidden');
      $("#cs2").addClass('hidden');
      $("#cs3").addClass('hidden');
      $(".apDiv2").addClass('hidden');
      $("#cs1_list").addClass('hidden');
      $("#cs2_list").addClass('hidden');
      $("#cs3_list").addClass('hidden');
      //$('.js-float-label-wrapper').FloatLabel();
      return this;
    },

    reRender: function () {
      var view = this, $form = $(this.form), productResult = DSP.models.Application__c.product__c,
          subProductResult = DSP.models.Application__c.sub_product__c,
          channel = DSP.models.Application__c.current_channel__c,
          assisted = DSP.models.Application__c.assisted_application__c,
          products_list;
      $(view.el).html(view.template(DSP.models));
      $('body').append('<div id="tmp-content" class="hidden">' + view.templatep(DSP.models) + '</div>');
      products_list = $('#tmp-content #products-list').html();
      $('#tmp-content').remove();
      $("#form-contents").html(view.templatep(DSP.models) );
      $("#cs1").addClass('hidden');
      $("#cs2").addClass('hidden');
      $("#cs3").addClass('hidden');
      $(".apDiv2").addClass('hidden');
      $("#cs1_list").addClass('hidden');
      $("#cs2_list").addClass('hidden');
      $("#cs3_list").addClass('hidden');
      $('#flags-container').addClass('hidden').parent().find('.breadcrumbs_list').addClass('hidden');
      //$('.submit_left').parent().find('a').addClass('hidden');
      view.channel = channel;
      if ($('html').hasClass('ie8')) {
        $('.selected-item').html('<span style="font-family: wingdings;">&#252;</span>');
      }
      //$('.header_background').css('display','none');

      if (view.channel === 'Online') {
        $('.cs1,.cs2,.cs3').each(function (idx, el) {
          var $th = $(this);
          if ($th.data('value')) {
            var prod = $th.data('value'), parts = prod.split(" - "), product = $.trim(parts[0]), subproduct = parts.slice(1).join('-');
            console.log('data(value):' + prod);
            console.log('class:' + $th.attr('class'));
            $('.apDiv1[data-link="' + $th.attr('class') + '"]').each(function (idx, el) {
              view.clickCrosssellItem(el);
            });
          }
        });
      }

      if (channel !== 'Online') {
        var $cs1 = $('.cs1_hidden'), $cs2 = $('.cs2_hidden'), $cs3 = $('.cs3_hidden');
        if (typeof DSP.controller !== undefined) {
          //Javascript remoting method here
          DSP.controller.productList(DSP.id, function (results, event) {
            if (event.status) {
              //console.log('Dropdown data is', results);
              for (var i = 0; i < results.length; i++) {
                // create an array entry for the product name if there is not one
                if (!view.products[results[i]]) {
                  view.products[results[i]] = [];
                  //console.log('results inside products are', view.products[results[i]]);
                }
              }
            } else {
              alert('could not contact server');
            }
          });

          DSP.controller.subProductList(DSP.id, function (results, event) {
            if (event.status) {
              //console.log('Sub product data is',results);
              for (var i = 0; i < results.length; i++) {
                var prod = results[i], parts = prod.split("_"), product = parts[0], subproduct = parts[1];
                //console.log('prod:' + prod);
                //console.log('product is', product);
                //console.log('parts are', parts);
                //console.log('subproduct is', subproduct );
                //console.log ('product:' + product, 'subproduct:' + subproduct);
                // create an array entry for the product name if there is not one
                if (!view.products[product]) {
                  view.products[product] = [];
                }
                // add the subproduct to the array for this product
                view.products[product].push(subproduct);
              }
              console.log('products:', view.products);
              $.each(view.products, function (index, value) {
                //console.log('Products are', view.products);
                //console.log('Index is', index);
                //console.log('Value is', value);
                var optgroup = $('<optgroup>');
                optgroup.attr('label', index);
                //console.log('index:', index, 'value:', value);
                $.each(value, function (i) {
                  var prod = value[i], parts = prod.split(" - "), subproduct = parts.slice(1).join('-');
                  //console.log('productresult is', productResult);
                  var dis = (index === productResult) ? 'disabled="disabled"' : '', option = $('<option ' + dis + '></option>');
                  option.val(value[i]);
                  option.text(subproduct);
                  optgroup.append(option);
                });
                //console.log('optgroup:', optgroup);
                $(".cross-select_1,.cross-select_2,.cross-select_3").append(optgroup);
              });
              $(document).ready(function(){
                $.each(['1', '2', '3'], function (idx, key) {
                  var cs_val = $('.cs' + key + '_hidden').val();
                  if (cs_val !== '') {
                    console.log('cs_val:' + cs_val);
                    var parts = cs_val.split(' - '), product = $.trim(parts[0]);
                    $('.cross-select_' + key).find('optgroup[label="' + product + '"]').find("> [value='" + cs_val + "']").attr("selected", "true").end().trigger('change');
                  }
                });
              //  DSP.setSelectOptions();
              });
            } else {
              alert('could not contact server');
            }
          });
        }

        var $selects = $('.cross-select_1,.cross-select_2,.cross-select_3'),
            crossProducts = {'1': {'product': ''}, '2': {'product': ''}, '3': {'product': ''}};
        $selects.each(function () {
          var $th = $(this), tmp = $th.attr('class').split(' '), parts = tmp[0].split('_'), crossNum = parts[1],
              $sel, $selected, parts2, product, subproduct, $val;
          //console.log('this:', this, 'parts:', parts);
          $th.on('change', function () {
            //console.log($('#cs' + crossNum));
            $selected = $(this).find('option:selected');
            $val = $selected.val();
            console.log('Value in dropdown is:' + $val);
            parts2 = $val.split('-');
            product = $.trim(parts2[0]);
            subproduct = parts2.slice(1).join('-');
            if ($.trim($val) === '') {
              $('#cs' + crossNum)
                  .addClass('hidden')
                  .find('input[type="checkbox"]')
                  .prop('checked', false);
            } else {
              $('#cs' + crossNum)
                  .find('.bodyText')
                  .html($val)
                  .end()
                  .removeClass('hidden')
                  .find('input[type="checkbox"]')
                  .prop('checked', true);
            }
            $('.cs' + crossNum + '_hidden').val($val);
            $('#cs' + crossNum + '_list').removeClass("hidden");
            $('#cs' + crossNum + '_list').html($val);
            $sel = $('#cs' + crossNum).find('.styled-select');
            //console.log('product:', product, 'sel:', $sel);
            $selects.find('optgroup[label="' + product + '"] option').each(function () {
              $(this).attr('disabled', true);
            });
            view.selectInsuranceProductSections(product, subproduct, $sel);
            crossProducts[crossNum]['product'] = product;
            $selects.find('optgroup').not('[label="' + productResult + '"]').each(function () {
              var $th = $(this), $label = $th.attr('label');
              $th.find('option').each(function () {
                //reset the disabled attribute on all options other than for primary product
                $(this).attr('disabled', false);
              });

              $.each(crossProducts, function (key) {
                //console.log('this', this,'this.product:', this.product, '$label:', $label, 'crossNum:', crossNum, 'key:', key);
                if (this.product === $label) {
                  //console.log('label:', $label, 'this:', this.product, 'key:', key);
                  $th.find('option').each(function () {
                    $(this).attr('disabled', true);
                  });
                }
              });
            });
            $th.find('optgroup[label="' + product + '"] option').each(function () {
              //Don't disable options for the current popup
              $(this).attr('disabled', false);
            });
            if ($.trim($val) === '') {
              $('#cs' + crossNum).find('input[type="checkbox"]').trigger('click');
              view.deSelectInsuranceProductSections(productResult, subProductResult);
            }
//            else {
//              $('#cs' + crossNum).find('input[type="checkbox"]').trigger('click');
//              view.deSelectDropdown();
//            }
          });
        });
        $('.gap_protection').on('change', function () {
          view.setIncludeGapProtection($(this).val());
        });
        $('.mbd_protection').on('change', function () {
          view.setIncludeMbdProtection($(this).val());
        });
        $('.include_mbd_protection').on('change', function () {
          view.setMbdPolicyAmount($(this).val());
        });
        view.setIncludeGapProtection($('.gap_protection').val());
        view.setIncludeMbdProtection($('.mbd_protection').val());
        view.setMbdPolicyAmount($('.include_mbd_protection').val());

        view.selectInsuranceProductSections(productResult, subProductResult, $('#pgAboutYou2').find('.styled-select'));

      } else if (assisted === 'true') {
        $(document).ready(function() {
          $.each(['1', '2', '3'], function (idx, key) {
            var $el = $('#cs' + key), $elcb = $el.find('input[type="checkbox"]');
            console.log('el:', $el);
            if ($elcb.data('value') !== '') {
              $elcb.prop('checked', true);
              $el.removeClass('hidden');
            }
          });
        });
      } else {
        if ($('.cross1').data('value') !== '') {
          $(".apDiv1[data-link='cs1']").trigger('click');
        }
        if ($('.cross2').data('value') !== '') {
          $(".apDiv1[data-link='cs2']").trigger('click');
        }
        if ($('.cross3').data('value') !== '') {
          $(".apDiv1[data-link='cs3']").trigger('click');
        }
      }
      /* date time picker*/
      DSP.dateTimeDetection();
      $('.schedule-appt').click(function(e) {
        DSP.previous(e, view.form, view.pageName, function() {
          Backbone.history.navigate("schedule", true);
        });
      });
      DSP.setFieldOptions();
      DSP.setSelectOptions();
      view.submitHandler();
      $('.js-float-label-wrapper').FloatLabel();
      DSP.afterRender(view.pageName, products_list);
      return this;
     },

//    deSelectDropdown: function() {
//      alert('inside deselect');
//    },
    setIncludeGapProtection: function (val) {
      if (val === 'Yes') {
        $('.include_gap_protection_div').removeClass('hidden');
      } else {
        $('.include_gap_protection_div').addClass('hidden');
      }
    },
    setIncludeMbdProtection: function (val) {
      if (val === 'Yes') {
        $('.include_mbd_protection_div').removeClass('hidden');
      } else {
        $('.include_mbd_protection_div, .mbd_policy_amount_div').addClass('hidden');
      }
    },
    setMbdPolicyAmount: function (val) {
      if (val === 'Yes') {
        $('.mbd_policy_amount_div').removeClass('hidden');
      } else if(val === 'No') {
        $('.mbd_policy_amount_div').addClass('hidden');
        $('.mbd_policy_amount').val('').removeClass('valid');
      }
    },
    deSelectInsuranceProductSections: function (productResult, subProductResult) {
      //console.log('deSelectInsuranceProductSections:', productResult, subProductResult);
      var val1 = $('.cross-select_1').find('option:selected').val(), parts1 = val1.split('-'),
          val2 = $('.cross-select_2').find('option:selected').val(), parts2 = val2.split('-'),
          val3 = $('.cross-select_3').find('option:selected').val(), parts3 = val3.split('-'),
          prod1 = parts1[0], subprod1 = parts1[1] || '', prod2 = parts2[0], subprod2 = parts2[1] || '',
          prod3 = parts3[0], subprod3 = parts3[1] || '';

      if (productResult !== 'Vehicle Loans' && prod1 !== 'Vehicle Loans' && prod2 !== 'Vehicle Loans' && prod3 !== 'Vehicle Loans') {
        $('.gap_protection_section').addClass('hidden');
        if (productResult !== 'Personal Loans' && prod1 !== 'Personal Loans' && prod2 !== 'Personal Loans' && prod3 !== 'Personal Loans') {
          $('.ds_protection_section').addClass('hidden');
        }
      }

      if (productResult !== 'Vehicle Loans' && prod1 !== 'Vehicle Loans' && prod2 !== 'Vehicle Loans' && prod3 !== 'Vehicle Loans' &&
          productResult !== 'Credit Cards' && prod1 !== 'Credit Cards' && prod2 !== 'Credit Cards' && prod3 !== 'Credit Cards' &&
          productResult !== 'Personal Loans' && prod1 !== 'Personal Loans' && prod2 !== 'Personal Loans' && prod3 !== 'Personal Loans') {
        $('.notes_section').addClass('hidden');
        $('.insurance_products_section').addClass('hidden');
      }

      if (productResult !== 'Credit Cards' && prod1 !== 'Credit Cards' && prod2 !== 'Credit Cards' && prod3 !== 'Credit Cards') {
        $('.ds_protection_cc_section').addClass('hidden');
      }

      if (productResult === 'Vehicle Loans' || prod1 === 'Vehicle Loans' || prod2 === 'Vehicle Loans' || prod3 === 'Vehicle Loans') {
        if (subProductResult.indexOf('Auto Loan') === -1 && subprod1.indexOf('Auto Loan') === -1 && subprod2.indexOf('Auto Loan') === -1
            && subprod3.indexOf('Auto Loan') === -1) {
          $('.mbd_protection_section').addClass('hidden');
        }
      } else {
        $('.mbd_protection_section').addClass('hidden');
      }
    },
    selectInsuranceProductSections: function (product, subproduct, $sel) {
      //console.log('selectInsuranceProductSections >>' + product + '<<', subproduct);
      //this.deSelectInsuranceProductSections(product, subproduct);
      switch (product) {
        case 'Vehicle Loans':
          $('.gap_protection_section').removeClass('hidden');
        case 'Credit Cards':
        case 'Personal Loans':
          if ($sel) {
            $sel.removeClass('hidden');
          }
          $('.notes_section').removeClass('hidden');
          $('.insurance_products_section').removeClass('hidden');
          break;
        default:
          if ($sel) {
            $sel.addClass('hidden');
          }
          break;
      }
      switch (product) {
        case 'Credit Cards':
          $('.ds_protection_cc_section').removeClass('hidden');
          break;
        case 'Vehicle Loans':
          if (subproduct.indexOf('Auto Loan') !== -1) {
            $('.mbd_protection_section').removeClass('hidden');
          }
        case 'Personal Loans':
          $('.ds_protection_section').removeClass('hidden');
          break;
      }
    }

  });
  return CrossSellPage;
});
