/**
 * Created by robertm on 12/6/13.
 */
/**
 *
 * -> PersonalInfo View
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
  'text!templates/purchase-details.html'
], function($, _, Backbone, Force, forcetk, bootstrap_datepicker, moment, hbs, validate, vmethods, floatlabel, jquery_datetime, dsp, dspc, appTemplate, pageTemplate){

  var PurchaseDetailsPage = Backbone.View.extend({

    el: '.container-fluid .form-contents',
    eld: '.container-fluid .disclosures',
    form: 'body#purchase-details form',

    template: hbs.compile(appTemplate),
    templatep: hbs.compile(pageTemplate),
    templated: '',

    events:{
      'click body#purchase-details #previous': 'prev',
    },

    url: DSP.custom_resources_url + "discount_points.json",
    productsData: {},

    submitHandler: function() {
      var view = this, $form = $(this.form);
      $form.validate();
      $form.data("validator").addCustomValidations(['currencyUS']);
      $form.data('submitted', false);
      $form.submit(function() {
        if (DSP.currentPage == view.pageName) {
          if ($form.data("validator").valid() && $form.data('submitted') !== true) {
            $form.find('input').trigger('reset');
            DSP.remotePostMethod($(view.form), view.pageName, 'property-details');
          }
        }
        return false;
      });
    },

    prev: function(e) {
      DSP.previous(e, this.form, this.pageName);
    },

    updateBuydownList: function(program, buydown_value) {
      $('.buydown').empty()
          .append($('<option></option>').val('').html('Discount Point/Buy Down<span class="required"> *</span>'));
      if (this.productsData[program]) {
        $.each(this.productsData[program], function (i, dp) {
          $('<option/>').val(dp).html(dp).appendTo('.buydown');
        });

        if (buydown_value) {
          //set the buydown list value
          $(".buydown > [value='" + buydown_value + "']").attr("selected", "true");
        }
      }
    },

    setOtherPurpose: function(obj) {
      if ($(obj).val() === 'Other') {
        $('.other_purpose').removeClass('hidden').parent().removeClass('hidden');
      } else {
        if ($('.appl_1_mortgageType').val() !== 'Other') {
          $('.other_purpose').addClass('hidden').parent().addClass('hidden');
        } else {
          $('.other_purpose').addClass('hidden');
        }
      }
    },

    setOtherType: function(obj) {
      if ($(obj).val() === 'Other') {
        $('.other_type').removeClass('hidden').parent().removeClass('hidden');
      } else {
        if ($('.appl_1_mortgagePurpose').val() !== 'Other') {
          $('.other_type').addClass('hidden').parent().addClass('hidden');
        } else {
          $('.other_type').addClass('hidden');
        }
      }
    },

    setRefiPurpose: function(obj) {
      if ($(obj).val() === 'Refi Rate/Term' || $(obj).val() === 'Refinance Cashout') {
        $('.hl_refi_fields').removeClass('hidden');
        $('.hl_purchase_fields').addClass('hidden');
      } else {
        $('.hl_refi_fields').addClass('hidden');
        $('.hl_purchase_fields').removeClass('hidden');
      }
    },

    setHEPurpose: function(obj) {
      if ($(obj).val() === 'Purchase') {
        $('.he_purchase_fields').removeClass('hidden');
        $('.he_homeequity_fields').addClass('hidden');
      } else {
        $('.he_purchase_fields').addClass('hidden');
        $('.he_homeequity_fields').removeClass('hidden');
      }
    },

    initialize: function(options) {
      $.extend(this, options);
      var view = this;
      view.render();
      $("body").css("cursor", "progress");
      DSP.remoteMethod(this.pageName, null, function(results) {
        view.reRender();
      });
    },

    render: function () {
      this.renderView();
      $('.js-float-label-wrapper').FloatLabel();
      return this;
    },

    renderView: function () {
      var view = this;
      hbs.registerPartial("form-contents", this.templatep(DSP.models));
      $('body').append('<div id="tmp-content" class="hidden">'+this.templatep(DSP.models)+'</div>');
      hbs.registerPartial("header-contents", $('#tmp-content #header-contents').html());
      hbs.registerPartial("action-panel", $('#tmp-content #action-panel').html());
      this.templated = $('#tmp-content #disclosures').html();
      $('#tmp-content').remove();
      $("body").attr("id","purchase-details");
      $(this.el).html(this.template(DSP.models));
      $(this.eld).html(this.templated);
      $("#form-contents").html(view.templatep(DSP.models) );
    },

    reRender: function () {
      var view = this, products_list;
      this.renderView();
      $('body').append('<div id="tmp-content" class="hidden">' + view.templatep(DSP.models) + '</div>');
      products_list = $('#tmp-content #products-list').html();
      $('#tmp-content').remove();

      //function to call on change of dropdown value
      $('.appl_1_mortgagePurpose').on('change', function () {
        view.setOtherPurpose(this);
      });
      $('.appl_1_mortgageType').on('change', function () {
        view.setOtherType(this);
      });
      $('.appl_1_mortgagePurpose').on('change', function () {
        view.setRefiPurpose(this);
      });
      $('.appl_1_equityPurpose').on('change', function () {
        view.setHEPurpose(this);
      });

      if ($('.appl_1_mortgageType').val() == 'Other') {
        view.setOtherType($('.appl_1_mortgageType'));
      }

      if ($('.appl_1_mortgagePurpose').val() == 'Other') {
        view.setOtherPurpose($('.appl_1_mortgagePurpose'));
      }

      if ($('.appl_1_mortgagePurpose').val() == 'Refinance Cashout' || $('.appl_1_mortgagePurpose').val() == 'Refi Rate/Term') {
        view.setRefiPurpose($('.appl_1_mortgagePurpose'));
      }
      if ($('.appl_1_equityPurpose').val() == 'Purchase') {
        view.setHEPurpose($('.appl_1_equityPurpose'));
      }

      //Adding a financial institute
      $('a.add_btn').on('click', function (e) {
        e.preventDefault();
        var el = $('#financialAssets').find('.hidden').first();
        $(el).removeClass('hidden');
        if ($(el).attr('id') === 'financialAsset6') {
          $(this).addClass('hidden');
        }
        if ($(el).attr('id') === 'financialAsset4') {
          $('a.delete_btn').removeClass('hidden');
        }
        return false;
      });

      //Deleting a financial institute
      $('a.delete_btn').on('click', function (e) {
        e.preventDefault();
        var el = $('#financialAssets').find('.fieldSet').not('.hidden').last();
        if ($(el).attr('id') === 'financialAsset4') {
          $(this).addClass('hidden');
        }
        $(el).addClass('hidden');
        if ($(el).attr('id') === 'financialAsset6') {
          $('a.add_btn').removeClass('hidden');
        }
        return false;
      });

      var dp_product = $('.program_description__c'), dp_buydown = $('.discount_pt_buydown__c');
      $.getJSON(view.url, function (products) {
        if (products) {
          $('.programDescription').empty()
              .append($('<option></option>').val('').html('Program Description<span class="required"> *</span>'));
          $.each(products, function (index) {
            view.productsData[products[index].program_description] = products[index].buydown_values;
            $('<option/>').val(products[index].program_description).html(products[index].program_description)
                .appendTo('.programDescription');
          });

          if (dp_product.val() !== '') {
            $('.programDescription option[value="' + dp_product.val() + '"]').attr('selected','selected');
            view.updateBuydownList(dp_product.val(), dp_buydown.val());
          }
        }
      });

      $('.programDescription').on('change', function () {
        view.updateBuydownList($(this).val());
        dp_product.val($(this).val());
      });
      $('.buydown').on('change', function () {
        dp_buydown.val($(this).val());
      });

      if (dp_product.val()) {
        view.updateBuydownList(dp_product.val());
        $('.programDescription option[value="' + dp_product.val() + '"]').attr('selected','selected');
      }
      if (dp_buydown.val()) {
        $('.buydown option[value="' + dp_buydown.val() + '"]').attr('selected','selected');
      }

      view.submitHandler();
      /* date time picker*/
      DSP.dateTimeDetection();
      $('.save-for-later').click(function(e) {
        DSP.previous(e, view.form, view.pageName, function() {
          Backbone.history.navigate("save-for-later", true);
        });
      });
      $('.schedule-appt').click(function(e) {
        DSP.previous(e, view.form, view.pageName, function() {
          Backbone.history.navigate("schedule", true);
        });
      });
      var txt = $('.formCopy').text();
      $('.formCopy').html(txt);
      $("body").css("cursor", "default");

      DSP.setFieldOptions();
      DSP.setSelectOptions();
      $('.js-float-label-wrapper').FloatLabel();
      $('#previous').attr('href', '#account-details');
      DSP.afterRender(view.pageName, products_list);
      return this;
    }

  });

  return PurchaseDetailsPage;
});
