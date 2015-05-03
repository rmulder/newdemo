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
  'text!templates/property-details.html'
], function($, _, Backbone, Force, forcetk, bootstrap_datepicker, moment, hbs, validate, vmethods, floatlabel, jquery_datetime, dsp, dspc, appTemplate, pageTemplate){

  var PropertyDetailsPage = Backbone.View.extend({

    el: '.container-fluid .form-contents',
    eld: '.container-fluid .disclosures',
    form: 'body#property-details form',

    template: hbs.compile(appTemplate),
    templatep: hbs.compile(pageTemplate),
    templated: '',

    events:{
      'click body#property-details #previous': 'prev'
    },

    submitHandler: function() {
      var view = this, $form = $(this.form);
      $form.validate();
      $form.data("validator").addCustomValidations(['durationYears', 'durationMonths', 'currencyUS']);
      $form.data('submitted', false);
      $form.submit(function() {
        if (DSP.currentPage == view.pageName) {
          if ($form.data("validator").valid() && $form.data('submitted') !== true) {
            $form.find('input').trigger('reset');
            DSP.remotePostMethod($(view.form), view.pageName, 'declarations');
          }
        }
        return false;
      });
    },

    prev: function(e) {
      DSP.previous(e, this.form, this.pageName);
    },

    updateCountyList: function(state, county, el) {
      var counties = [], i;
      $(el).empty()
          .append($('<option></option>').val('').html('County<span class="required"> *</span>'));
      if (state) {
        $("body").css("cursor", "progress");
        DSP.controller.getCountiesByState(state, function (result, event) {
          if (event.status) {
            $.each(result, function (i, county) {
              counties.push(county.County_Name__c);
            });
            for (i = 0; i < counties.length; i++) {
              $('<option/>').val(counties[i]).html(counties[i]).appendTo(el);
            }

            $(el + " > [value='" + county + "']").attr("selected", "true");
            $("body").css("cursor", "default");
          } else {
            console.log('error:', e.stack);
            $("body").css("cursor", "default");
            alert('An error has occurred: ' + e.message);
          }
        });
      }
      //set the county
      $(el + " > [value='" + county + "']").attr("selected", "true");
    },

    initialize: function(options) {
      $.extend(this, options);
      var view = this;
      if (DSP.preload) {
        view.render();
      }
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
      $("body").attr("id","property-details");
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
      view.submitHandler();
      //changing the counties according to the selected date
      $('.appl_1_state').on('change', function () {
        view.updateCountyList($(this).val(), false, '.appl_1_citizenCounty');
      });
      $('.appl_1_he_state').on('change', function () {
        view.updateCountyList($(this).val(), false, '.appl_1_heCounty');
      });

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

      $('.appl_1_citizenCounty').on('change', function () {
        switch($('.addressType tr td input[type=radio]:checked').val()) {
          case 'New Address':
            $('.new_county').val($(this).val());
            break;
          case 'Current Address':
            $('.current_county').val($(this).val());
            $('.new_county').val($(this).val());
            break;
        }
      });
      $('.appl_1_heCounty').on('change', function () {
        switch($('.heAddressType tr td input[type=radio]:checked').val()) {
          case 'No':
            $('.he_county').val($(this).val());
            break;
          case 'Yes':
            $('.current_county').val($(this).val());
            $('.he_county').val($(this).val());
            break;
        }
      });

      //Changing the fields according to the address selected
      $('input[type=radio].addressType').on('click', function () {
        switch ($(this).val()) {
          case 'Unknown Address':
            $('#addressInfo').addClass('hidden');
            $('.address1').removeAttr('validate');
            $('.city').removeAttr('validate');
            $('.state').removeAttr('validate');
            $('.county').removeAttr('validate');
            $('.zipcode').removeAttr('validate');
            break;
          case 'New Address':
            $('#addressInfo').removeClass('hidden');
            var addr1 = $(".new_address1").val() || '',
                addr2 = $(".new_address2").val() || '',
                city = $(".new_city").val() || '',
                state = $(".new_state").val() || '',
                county = $(".new_county").val() || '',
                zip = $(".new_zipcode").val() || '';
            //console.log('county:', county, 'state:', state);
            if (addr1 !== '') {
              $(".address1_label").hide();
            } else {
              $(".address1_label").show();
            }
            $(".address2").val(addr2).trigger('focus');
            if (addr2 !== '') {
              $(".address2_label").hide();
            } else {
              $(".address2_label").show();
            }
            $(".city").val(city).trigger('focus');
            if (city !== '') {
              $(".city_label").hide();
            } else {
              $(".city_label").show();
            }
            $(".state").val(state);
            $(".county").val(county);
            $(".zipcode").val(zip).trigger('focus');
            if (zip !== '') {
              $(".zipcode_label").hide();
            } else {
              $(".zipcode_label").show();
            }

            $(".address1").val(addr1).trigger('focus');
            view.updateCountyList(state, county, '.appl_1_citizenCounty');
            $('.address1').attr('validate', '"required:true"');
            $('.city').attr('validate', '"required:true"');
            $('.state').attr('validate', '"required:true"');
            $('.county').attr('validate', '"required:true"');
            $('.zipcode').attr('validate', '"required:true"');
            break;
          case 'Current Address':
          default:
            $('#addressInfo').removeClass('hidden');
            var addr1 = $(".current_address1").val() || '',
                addr2 = $(".current_address2").val() || '',
                city = $(".current_city").val() || '',
                state = $(".current_state").val() || '',
                county = $(".current_county").val() || '',
                zip = $(".current_zipcode").val() || '';
            state = (state.trim() === 'State*') ? '' : state;
            $(".address1").val(addr1).trigger('focus');
            if (addr1 !== '') {
              $(".address1_label").hide();
            } else {
              $(".address1_label").show();
            }
            $(".address2").val(addr2).trigger('focus');;
            if (addr2 !== '') {
              $(".address2_label").hide();
            } else {
              $(".address2_label").show();
            }
            $(".city").val(city).trigger('focus');
            if (city !== '') {
              $(".city_label").hide();
            } else {
              $(".city_label").show();
            }
            $(".state").val(state).trigger('focus');
            $(".county").val(county);
            $(".zipcode").val(zip).trigger('focus');;
            if (zip !== '') {
              $(".zipcode_label").hide();
            } else {
              $(".zipcode_label").show();
            }
            $(".address1").val(addr1).trigger('focus');
            //console.log('state:', state, 'county:', county);
            view.updateCountyList(state, county, '.appl_1_citizenCounty');
            $('.address1').attr('validate', '"required:true"');
            $('.city').attr('validate', '"required:true"');
            $('.state').attr('validate', '"required:true"');
            $('.county').attr('validate', '"required:true"');
            $('.zipcode').attr('validate', '"required:true"');
            break;
        }
      });

      $('input[type=radio].heAddressType').on('click', function () {
        switch ($(this).val()) {
          case 'No':
            var addr1 = $(".he_address1").val() || '',
                addr2 = $(".he_address2").val() || '',
                city = $(".he_city").val() || '',
                state = $(".he_state").val() || '',
                county = $(".he_county").val() || '',
                zip = $(".he_zipcode").val() || '';
            //console.log('county:', county, 'state:', state);
            $(".eaddress1").val(addr1);
            if (addr1 !== '') {
              $(".eaddress1_label").hide();
            } else {
              $(".eaddress1_label").show();
            }
            $(".eaddress2").val(addr2);
            if (addr2 !== '') {
              $(".eaddress2_label").hide();
            } else {
              $(".eaddress2_label").show();
            }
            $(".ecity").val(city);
            if (city !== '') {
              $(".ecity_label").hide();
            } else {
              $(".ecity_label").show();
            }
            $(".estate").val(state);
            $(".ecounty").val(county);
            $(".ezipcode").val(zip);
            if (zip !== '') {
              $(".ezipcode_label").hide();
            } else {
              $(".ezipcode_label").show();
            }
            view.updateCountyList(state, county, '.appl_1_heCounty');

            $('.eaddress1').attr('validate', '"required:true"');
            $('.ecity').attr('validate', '"required:true"');
            $('.estate').attr('validate', '"required:true"');
            $('.ecounty').attr('validate', '"required:true"');
            $('.ezipcode').attr('validate', '"required:true"');

            break;
          case 'Yes':
          default:
            var addr1 = $(".current_address1").val() || '',
                addr2 = $(".current_address2").val() || '',
                city = $(".current_city").val() || '',
                state = $(".current_state").val() || '',
                county = $(".current_county").val() || '',
                zip = $(".current_zipcode").val() || '';
            state = (state.trim() === 'State*') ? '' : state;
            $(".eaddress1").val(addr1);
            if (addr1 !== '') {
              $(".eaddress1_label").hide();
            } else {
              $(".eaddress1_label").show();
            }
            $(".eaddress2").val(addr2);
            if (addr2 !== '') {
              $(".eaddress2_label").hide();
            } else {
              $(".eaddress2_label").show();
            }
            $(".ecity").val(city);
            if (city !== '') {
              $(".ecity_label").hide();
            } else {
              $(".ecity_label").show();
            }
            $(".estate").val(state);
            $(".ecounty").val(county);
            $(".ezipcode").val(zip);
            if (zip !== '') {
              $(".ezipcode_label").hide();
            } else {
              $(".ezipcode_label").show();
            }
            //console.log('state:', state, 'county:', county);
            view.updateCountyList(state, county, '.appl_1_heCounty');

            $('.eaddress1').attr('validate', '"required:true"');
            $('.ecity').attr('validate', '"required:true"');
            $('.estate').attr('validate', '"required:true"');
            $('.ecounty').attr('validate', '"required:true"');
            $('.ezipcode').attr('validate', '"required:true"');

            break;
        }
      });

      $('form').validate();
      $("form").data("validator").addCustomValidations(['year']);
      var sel= $('.addressType tr td input[type=radio]:checked');
      if (sel.val()) {
        $(sel).trigger('click');
      } else {
        $('.addressType3').trigger('click');
      }

      $('form').on('submit', function () {
        //return false;
        if ($('.addressType tr td input[type=radio]:checked').val() === 'Current Address') {
          $('.new_county').val($('.appl_1_citizenCounty').val());
        }
      });

      $('body').on('keyup click focus blur','.hoa,.grossRental',function(e){
        var $input = $(this),
            hoaValue = $input.val(),
            $label = $input.siblings('label');

        if (hoaValue == '') {
          $label.show();
        } else {
          $label.hide();
        }
      });

      /* date time picker*/
      DSP.dateTimeDetection();
      $('div.radioGroup').each(function() {
        var $th = $(this);
        if ($th.data('value') !== '') {
          $th.find('input[type=radio][value="' + $th.data('value') + '"]').attr('checked', 'checked');
        }
      });
      $('#occupancy__c').change(function() {
        if ($(this).val().indexOf('Investment') !== -1) {
          $('#estimated_gross_rental_income__c').closest('.fieldSet').removeClass('hidden');
        } else {
          $('#estimated_gross_rental_income__c').closest('.fieldSet').addClass('hidden');
        }
      });
      $('#property_type__c').change(function() {
        if ($(this).val().indexOf('Condo') !== -1) {
          $('#hoa_dues__c').closest('.fieldSet').removeClass('hidden');
        } else {
          $('#hoa_dues__c').closest('.fieldSet').addClass('hidden');
        }
      });

      $('#he_occupancy__c').change(function() {
        if ($(this).val().indexOf('Investment') !== -1) {
          $('#he_estimated_gross_rental_income__c').closest('.fieldSet').removeClass('hidden');
        } else {
          $('#he_estimated_gross_rental_income__c').closest('.fieldSet').addClass('hidden');
        }
      });
      $('#he_property_type__c').change(function() {
        if ($(this).val().indexOf('Condo') !== -1) {
          $('#he_hoa_dues__c').closest('.fieldSet').removeClass('hidden');
        } else {
          $('#he_hoa_dues__c').closest('.fieldSet').addClass('hidden');
        }
      });
      
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
      var $state_aboutaccount__c = $('#state_aboutaccount__c');
      if ($state_aboutaccount__c.data('value') === '') {
        if ($('.current_state').val() !== '') {
          $("#state_aboutaccount__c > [value='" + $('.current_state').val() + "']").attr("selected", "true");
        }
      } else {
        $("#state_aboutaccount__c > [value='" + $state_aboutaccount__c.data('value') + "']").attr("selected", "true");
      }

      if ($('.appl_1_state').val() != '' && $('.appl_1_citizenCounty').val()) {
        view.updateCountyList($(this).val(), false, '.appl_1_citizenCounty');
      }
      if ($('.appl_1_he_state').val() != '' && $('.appl_1_heCounty').val()) {
        view.updateCountyList($(this).val(), false, '.appl_1_heCounty');
      }

      $("body").css("cursor", "default");
      DSP.setFieldOptions();
      DSP.setSelectOptions();
      $('.js-float-label-wrapper').FloatLabel();
      $('#previous').attr('href', '#purchase-details');
      DSP.afterRender(view.pageName, products_list);
      return this;
    }

  });

  return PropertyDetailsPage;
});
