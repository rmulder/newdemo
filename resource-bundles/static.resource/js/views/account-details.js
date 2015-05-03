/**
 * Created by robertm on 12/6/13.
 */
/**
 *
 * -> AccountDetails View
 */
//Libraries that are loaded by require.js
define([
  'jquery',
  'underscore',
  'backbone',
  'Backbone.Force',
  'forcetk.ui',
  'moment',
  'Handlebars',
  'jquery.validate',
  'jquery.validate.methods',
  'jquery.floatlabel',
  'jquery_datetime',
  'dsp',
  'dsp.common',
  'text!templates/application.html',
  'text!templates/account-details.html'
], function($, _, Backbone, Force, forcetk, moment, hbs, validate, vmethods, floatlabel, jquery_datetime, dsp, dspc, appTemplate, pageTemplate){

  var AccountDetailsPage = Backbone.View.extend({

    el: '.container-fluid .form-contents',
    eld: '.container-fluid .disclosures',
    form: 'body#account-details form',

    template: hbs.compile(appTemplate),
    templatep: hbs.compile(pageTemplate),
    templated: '',
    $vyear: '',
    $vmake: '',
    $vmodel: '',
    $vsubmodel: '',

    events:{
      //'click button[type=submit].myButton': 'submit',
      'click body#account-details #previous': 'prev',
      'keyup .error': 'validateField'
    },

    validateField: function(e) {
      //$(e.currentTarget).valid();
    },

    submitHandler: function() {
      var view = this, $form = $(this.form);
      $form.validate();
      $form.data('submitted', false);
      $form.submit(function() {
        if (DSP.currentPage == view.pageName) {
          if ($form.data("validator").valid() && $form.data('submitted') !== true) {
            $form.find('input,textarea').trigger('reset');
            DSP.remotePostMethod($j(view.form), view.pageName, 'purchase-details');
          }
        }
        return false;
      });
    },

    prev: function(e) {
      alert('called prev from account-details');
      DSP.previous(e, this.form, this.pageName);
    },

    submit: function(e) {
      e.preventDefault();
      e.stopPropagation();
      DSP.remotePostMethod($(this.form), this.pageName, 'purchase-details');
    },

    initialize: function(options){
      $.extend(this, options);
      var view = this;
      if (DSP.preload) {
        view.render();
      }
      $("body").css("cursor", "progress");
      DSP.remoteMethod(this.pageName, null, function(results) {
        view.reRender();
        $("body").css("cursor", "default");
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
      $("body").attr("id","account-details");
      $(this.el).html(this.template(DSP.models));
      $(this.eld).html(this.templated);
      $("#form-contents").html(view.templatep(DSP.models));
    },

    reRender: function () {
      var view = this;
      this.renderView();
      $('.checkingInfo,.savingsInfo,.certInfo,.buscheckingInfo,.bussavingsInfo,.buscertInfo').each(function() {
        var $th = $(this);
        //This event is triggered whenever the value in the dropdown changes
        $th.find('.fundingType').on('change', function () {
          if($('.fundingType').val() === 'Add External Accounts') {
            $th.find('.external').removeClass('hidden');
            $('.external').find('input[type=text],select').addClass('required');
          }
          else {
            $('.external').find('input[type=text],select').removeClass('required');
          }
          //$th.find('.external').removeClass('hidden');
          $th.find('.internal').addClass('hidden');
          $th.find('.external').addClass('hidden');
          $th.find('.cash').addClass('hidden');
          $th.find('.check').addClass('hidden');
          
          if ($(this).val() !== '') {
            if ($(this).val() === 'Cash') {
              $th.find('.cash').removeClass('hidden');
              $('.cash').find('input[type=text]').addClass('required');
            } 
            else if ($(this).val() === 'Check') {
              $th.find('.check').removeClass('hidden');
              $('.check').find('input[type=text]').addClass('required');
            }
            else if ($(this).val() === 'Internal Accounts') {
              $th.find('.internal').removeClass('hidden');
              $('.internal').find('input[type=text],select').addClass('required');
            } else {
              $th.find('.external').removeClass('hidden');
              $('.internal').find('input[type=text],select').removeClass('required');
              $('.cash').find('input[type=text],select').removeClass('required');
              $('.check').find('input[type=text],select').removeClass('required');
            }
          }
        });
      });
//      $(document).ready(function() {
//        $(".fundingType").change();
//      })
      $( ".appl_1_ccpaymentmethod" ).change(function() {
        if($('.appl_1_ccpaymentmethod').val() === 'ACH Transfer') {
          $('.CC_ACHtransfer').removeClass('hidden');
        }
        else{
          $('.CC_ACHtransfer').addClass('hidden');
        }

      });

      $( ".appl_1_vlpaymentmethod" ).change(function() {
        if($('.appl_1_vlpaymentmethod').val() === 'ACH Transfer') {
          $('.VL_ACHtransfer').removeClass('hidden');
        }
        else{
          $('.VL_ACHtransfer').addClass('hidden');
        }
      });

      $( ".appl_1_plpaymentmethod" ).change(function() {
        if($('.appl_1_plpaymentmethod').val() === 'ACH Transfer') {
          $('.PL_ACHtransfer').removeClass('hidden');
        }
        else{
          $('.PL_ACHtransfer').addClass('hidden');
        }
      });

      $('input[type=checkbox]').each(function() {
        var $th = $(this);
        if ($th.data('value')) {
          $th.attr('checked', 'checked');
        }
      });
      $('input[class*=hamdaNoDecl]').each(function() {
        var $th = $(this);
        if ($th.data('value') === 'true') {
          $th.attr('checked', 'checked');
        }
      });
      var hamda_arr = [], tmpobj;
      for (var i = 1; i < 5; i++) {
        tmpobj = {
          selector: 'appl_'+i+'_hamdaNoDecl',
          index: i
        };
        hamda_arr.push(tmpobj);
      }

      $.each(hamda_arr, function () {
        var th = this, $current = $('.'+th.selector);
        if ($current.is(":checked")) {
          $('.appl_'+th.index+'_ethnicity').prop("disabled", true).removeClass('required');
          $('.appl_'+th.index+'_Sex').prop("disabled", true).removeClass('required');
          $j('.appl_'+th.index+'_race').prop("disabled",true);
          $('form').validate();
        }
        $current.click(function() {
          if ($(this).is(":checked")) {
            $('.appl_'+th.index+'_ethnicity').prop("disabled", true).removeClass('required');
            $('.appl_'+th.index+'_Sex').prop("disabled", true).removeClass('required');
            $j('.appl_'+th.index+'_race').prop("disabled",true);
            $('form').validate();
          } else {
            $('.appl_'+th.index+'_ethnicity').prop("disabled", false).addClass('required');
            $('.appl_'+th.index+'_Sex').prop("disabled", false).addClass('required');
            $j('.appl_'+th.index+'_race').prop("disabled",false);
            $('form').validate();
          }
        });
      });
      if ($( ".appl_1_vehicleYear").val() == '') {
        $(".appl_1_vehicleMake").prop("disabled", true);
      }
      if ($( ".appl_1_vehicleMake").val() == '') {
        $(".appl_1_vehicleModel").prop("disabled", true);
      }
      if ($( ".appl_1_vehicleModel").val() == '') {
        $(".appl_1_vehicleSubModel").prop("disabled", true);
      }
      $( ".appl_1_vehicleYear" ).change(function() {
        if ($( ".appl_1_vehicleYear").val() != '') {
          $(".appl_1_vehicleMake").removeAttr('disabled');
        } else {
          $(".appl_1_vehicleMake").prop("disabled", true);
        }
      });
      $( ".appl_1_vehicleMake" ).change(function() {
        if ($( ".appl_1_vehicleMake").val() != '')  {
          $(".appl_1_vehicleModel").removeAttr('disabled');
        } else {
          $(".appl_1_vehicleModel").prop("disabled", true);
        }
      });
      $( ".appl_1_vehicleModel" ).change(function() {
        if ($( ".appl_1_vehicleModel").val() != '')   {
          $(".appl_1_vehicleSubModel").removeAttr('disabled');
        } else {
          $(".appl_1_vehicleSubModel").prop("disabled", true);
        }
      });

      $('.loanPurpose').each(function(idx, el) {
        $(el).on('change', function () {
          if ($(this).val().indexOf('Other') !== -1) {
            $(el).closest('.loanInfo').find('.other_loan_purpose')
                .removeClass('hidden').find('input').attr('validate', '"required:true"');
          } else {
            $(el).closest('.loanInfo').find('.other_loan_purpose')
                .addClass('hidden').find('input').removeAttr('validate');
          }

          if ($(this).val() === 'Debt Consolidation') {
            $(el).closest('.loanInfo').find('.debt_consolidation_purpose')
                .removeClass('hidden').find('input').attr('validate', '"required:true"');
          } else {
            $(el).closest('.loanInfo').find('.debt_consolidation_purpose')
                .addClass('hidden').find('input').removeAttr('validate');
          }
        });
      });
      
      $('.loanDecl').each(function(idx, el) {
        $(el).on('change', function () {

          if ($(this).val() === 'Home Improvement') {
            $('.appl_1_HMDA').removeClass('hidden');
            $('.appl_2_HMDA').removeClass('hidden');
            $('.appl_3_HMDA').removeClass('hidden');
            $('.appl_4_HMDA').removeClass('hidden');
          } else {
            $('.appl_1_HMDA').addClass('hidden');
            $('.appl_2_HMDA').addClass('hidden');
            $('.appl_3_HMDA').addClass('hidden');
            $('.appl_4_HMDA').addClass('hidden');
          }
          
        });
      });    


      $('.creditPurpose').each(function(idx, el) {
        $(el).on('change', function () {
          if ($(this).val().indexOf('Other') !== -1) {
            $(el).closest('.creditInfo').find('.other_credit_purpose')
                .removeClass('hidden').find('input').attr('validate', '"required:true"');
          } else {
            $(el).closest('.creditInfo').find('.other_credit_purpose')
                .addClass('hidden').find('input').removeAttr('validate');
          }

          if ($(this).val() === 'Debt Consolidation') {
            $(el).closest('.creditInfo').find('.debt_consolidation_purpose')
                .removeClass('hidden').find('input').attr('validate', '"required:true"');
          } else {
            $(el).closest('.creditInfo').find('.debt_consolidation_purpose')
                .addClass('hidden').find('input').removeAttr('validate');
          }
        });
      });

      $('.buscreditPurpose').each(function(idx, el) {
        $(el).on('change', function () {
          if ($(this).val().indexOf('Other') !== -1) {
            $(el).closest('.buscreditInfo').find('.other_bus_credit_purpose')
                .removeClass('hidden').find('input').attr('validate', '"required:true"');
          } else {
            $(el).closest('.buscreditInfo').find('.other_bus_credit_purpose')
                .addClass('hidden').find('input').removeAttr('validate');
          }

          if ($(this).val() === 'Debt Consolidation') {
            $(el).closest('.buscreditInfo').find('.debt_consolidation_bus_purpose')
                .removeClass('hidden').find('input').attr('validate', '"required:true"');
          } else {
            $(el).closest('.buscreditInfo').find('.debt_consolidation_bus_purpose')
                .addClass('hidden').find('input').removeAttr('validate');
          }
        });
      });

      $('form').validate();
      //$('form').on('submit', function (e) {alert('');e.preventDefault(); return false;});
      $("form").data("validator")
          .addCustomValidations(['routingNumber', 'accountNumber', 'currencyUS']);

      $('.formFields[id*=appl_]').each(function() {
        var $th = $(this);
        $th.find('input[type="radio"]').click(function () {
          var name = $(this).attr('id'), val = $(this).val(), parts = name.split('_'),
              desc = 'desc' + parts[1] + '_' + parts[2].substr(4), div = desc + '_div';
          if (val === 'true') {
            $('#' + div).show('slow');
            $('#' + desc).addClass('required');
          } else {
            $('#' + div).hide();
            $('#' + desc).removeClass('required');
          }
        });
      });
      $("#prefill_savings").click(function() {
        if($("#prefill_savings").prop('checked')==true && $("#financial_institution_chk__c").val()!=='') {
          $("#financial_institution_sav__c").val($("#financial_institution_chk__c").val());
          $("#routing_number_sav__c").val($("#routing_number_chk__c").val());
          $("#account_type_fi_sav__c").val($("#account_type_fi_chk__c").val());
          $("#sav_account_number__c").val($("#chk_account_number__c").val());
        }
         else if($("#prefill_savings").prop('checked')==false) {
          $("#financial_institution_sav__c").val('');
          $("#routing_number_sav__c").val('');
          $("#account_type_fi_sav__c").val('');
          $("#sav_account_number__c").val('');
          $("#dollar_amount_external_sav__c").val('');
        }
      });
      var chkBankName = $("#financial_institution_chk__c").val();
      var savBankName = $("#financial_institution_sav__c").val();
      var certBankName = $("#financial_institution_cert__c").val();
      //var chkBankElem = $("#financial_institution_chk__c");
      $("#prefill_certificates").click(function() {
        if(chkBankName !== undefined ) {
          if ($("#prefill_certificates").prop('checked') == true) {
            $("#financial_institution_cert__c").val($("#financial_institution_chk__c").val());
            $("#routing_number_cert__c").val($("#routing_number_chk__c").val());
            $("#account_type_fi_cert__c").val($("#account_type_fi_chk__c").val());
            $("#cert_account_number__c").val($("#chk_account_number__c").val());
          }
        }
        else if(chkBankName === undefined ){
          $("#financial_institution_cert__c").val($("#financial_institution_sav__c").val());
          $("#routing_number_cert__c").val($("#routing_number_sav__c").val());
          $("#account_type_fi_cert__c").val($("#account_type_fi_sav__c").val());
          $("#cert_account_number__c").val($("#sav_account_number__c").val());
        }
         if($("#prefill_certificates").prop('checked')==false) {
          $("#financial_institution_cert__c").val('');
          $("#routing_number_cert__c").val('');
          $("#account_type_fi_cert__c").val('');
          $("#cert_account_number__c").val('');
        }
      });

    if(chkBankName!=='' && chkBankName === savBankName) {
        $("#prefill_savings").prop('checked', true);
      }
      if(savBankName!=='' && savBankName === certBankName) {
        $("#prefill_certificates").prop('checked', true);
      }
      else if((chkBankName !== undefined && chkBankName.length!==0)&& (chkBankName=== certBankName) ) {
        $("#prefill_certificates").prop('checked', true);
      }
      var url = DSP.custom_resources_url + 'branch_locations.json';
      var ic_state = $('.investment_consultation_state').val(), ic_city = $('.investment_consultation_city').val();
      $.getJSON(url, function (locations) {
        if (locations) {
          $.each(locations, function (index) {
            var optgroup = $('<optgroup>');
            optgroup.attr('label', locations[index].branch_state);

            $.each(locations[index].branch_locations, function (i) {
              var option = $("<option></option>");
              option.val(locations[index].branch_state_code + '_' + locations[index].branch_locations[i]);
              option.text(locations[index].branch_locations[i]);

              optgroup.append(option);
            });
            $(".ic_branch_location").append(optgroup);
          });
        }
      });

      if (ic_state !== '' && ic_city !== '') {
        $('.ic_branch_location').val(ic_state + '_' + ic_city);
      }

      $('.ic_branch_location').on('change', function () {
        var sel = $(this).val(), parts = sel.split('_');
        if (sel !== '') {
          $('.investment_consultation_state').val(parts[0]);
          $('.investment_consultation_city').val(parts[1]);
        }
      });
      $('.formFields[id*=decl]').each(function() {
        var $th = $(this);
        if ($th.data('value') !== '') {
          $th.find('input[type=radio][value="' + $th.data('value') + '"]').attr('checked', 'checked');
        }
      });
      $('div.formFields[id*=decl]').each(function() {
        var $th = $(this), submitted = $('#AccountDetailsPageSubmitted').val();
        if (submitted === 'true') {
          $th.find('input[type=radio][value="' + $th.data('value') + '"]').attr('checked', 'checked');
        }
        $th.find('input[type="radio"]').not('.1_1').click(function() {
          var val = $(this).val(), $ta = $th.find('textarea');
          if (val === 'true') {
            $ta.parent().removeClass('hide');
          } else {
            $ta.parent().addClass('hide');
          }
        });
      });
      $('.formFields[id*=busaa]').each(function() {
        var $th = $(this);
        if ($th.data('value') !== '') {
          $th.find('input[type=radio][value="' + $th.data('value') + '"]').attr('checked', 'checked');
        }
      });
      $('div.formFields[id*=busaa]').each(function() {
        var $th = $(this), submitted = $('#AccountDetailsPageSubmitted').val();
        if (submitted === 'true') {
          $th.find('input[type=radio][value="' + $th.data('value') + '"]').attr('checked', 'checked');
        }
        $th.find('input[type="radio"]').not('.1_1').click(function() {
          var val = $(this).val(), $ta = $th.find('textarea');
          if (val === 'true') {
            $ta.parent().removeClass('hide');
          } else {
            $ta.parent().addClass('hide');
          }
        });
      });

      view.submitHandler();
      $('input[type=radio]').each(function () {
        $(this).rules('add', {
          required: true,
          messages: {
            required: "Select an option"
          }
        });
      });
      $('input[type=radio]:checked').each(function (indx, el) {
        el.click();
      });
      var $req_la_vl = $('#requested_loan_amount_vehicleloans__c'),
          $req_la_pl = $('#requested_loan_amount_personalloans__c'),
          $req_la_bl = $('#requested_loan_amount_businessloans__c'),
          $req_cl_pl = $('#requested_credit_limit_personalloans__c'),
          $req_cl_bcc = $('#requested_credit_limit_bus_ccards__c'),
          $req_cl_cc = $('#requested_credit_limit_ccards__c');

      $req_la_vl.on('blur', function() {view.getTerms($req_la_vl);});
      $req_la_pl.on('blur', function() {view.getTerms($req_la_pl);});
      $req_la_bl.on('blur', function() {view.getTerms($req_la_bl);});
      $req_cl_pl.on('blur', function() {view.getTerms($req_cl_pl);});
      $req_cl_cc.on('blur', function() {view.getTerms($req_cl_cc);});
      $req_cl_bcc.on('blur', function() {view.getTerms($req_cl_bcc);});

      $('#dollar_amount_external_chk__c, #dollar_amount_external_sav__c, #dollar_amount_external_bus_chk__c, #dollar_amount_external_bus_sav__c, #dollar_amount_external_bus_cds__c,'+
        '#dollar_amount_external_cert__c,#dollar_amount_busichk_check__c,#dollar_amount_busichk_cash__c,#dollar_amount_busisav_check__c,#dollar_amount_busisav_cash__c,#dollar_amount_busicds_check__c,'+
        '#dollar_amount_busicds_cash__c,#dollar_amount_chk_check__c,#dollar_amount_chk_cash__c,#dollar_amount_sav_check__c,'+
        '#dollar_amount_sav_cash__c,#dollar_amount_cert_check__c,#dollar_amount_cert_cash__c').on('blur', function() {
        var $th = $(this), field = $th.prop('id');
        if ($th.val().length > 2) {
          var data = {id: DSP.id, ut: DSP.ut, requested_amount: $th.val(), field: field};
          //console.log('calling getTerms:', data);
          $('#error_' + field).html('').addClass('hidden');
          DSP.controller.validateDollarAmount(data, function (results, event) {
            //console.log('remoteMethod getTerms:', results, 'event:', event);
            if (event.status) {
              if (results === null) {
                alert('no response from server');
              } else {
                //console.log('results:', results);
                if (results['error_' + field]) {
                  $('#error_' + field).html(results['error_' + field].replace("\n", "<br/>")).removeClass('hidden');
                }
              }
            } else {
              alert('could not contact server');
            }
          });
        }
      });

      /* date time picker*/
      DSP.dateTimeDetection();
      view.$vyear = $('#vehicleyear__c'), view.$vmake = $('#vehiclemake__c'), view.$vmodel = $('#vehiclemodel__c'),
          view.$vsubmodel = $('#vehicle_sub_model__c');
      view.$vyear.change(function() {
        view.vYearChange(this);
      });
      view.$vmake.change(function() {
        view.vMakeChange(this);
      });
      view.$vmodel.change(function() {
        view.vModelChange(this);
      });

      if (view.$vyear.data('value')) {
        console.log('vyear:', view.$vyear.data('value'));
        view.$vyear.find("> [value='" + view.$vyear.data('value') + "']").attr("selected", "true");
        view.vYearChange(view.$vyear, function() {
          console.log('$vmake:', view.$vmake.data('value'));
          if (view.$vmake.data('value')) {
            $(view.$vmake).find("> [value='" + $(view.$vmake).data('value').toUpperCase() + "']").attr("selected", "true");
            view.vMakeChange(view.$vmake, function() {
              console.log('$vmodel:', view.$vmodel.data('value'));
              if (view.$vmodel.data('value')) {
                $(view.$vmodel).find("> [value='" + $(view.$vmodel).data('value') + "']").attr("selected", "true");
                view.vModelChange(view.$vmodel, function() {
                  console.log('$vsubmodel:', view.$vsubmodel.data('value'));
                  if (view.$vsubmodel.data('value')) {
                    $(view.$vsubmodel).find("> [value='" + $(view.$vsubmodel).data('value') + "']").attr("selected", "true");
                  }
                });
              }
            });
          }
        });
      }

      if ($req_la_vl.val()) {
        view.getTerms($req_la_vl, function() {
          var $sel = $('#' + $($req_la_vl).data('select'));
          $sel.find("> [value='" + $sel.data('value') + "']").attr("selected", "true");
        });
      }
      if ($req_la_pl.val()) {
        view.getTerms($req_la_pl, function() {
          var $sel = $('#' + $($req_la_pl).data('select'));
          $sel.find("> [value='" + $sel.data('value') + "']").attr("selected", "true");
        });
      }
      if ($req_la_bl.val()) {
        view.getTerms($req_la_bl, function() {
          var $sel = $('#' + $($req_la_bl).data('select'));
          $sel.find("> [value='" + $sel.data('value') + "']").attr("selected", "true");
        });
      }
      if ($req_cl_pl.val()) {
        view.getTerms($req_cl_pl, function() {
          var $sel = $('#' + $($req_cl_pl).data('select'));
          $sel.find("> [value='" + $sel.data('value') + "']").attr("selected", "true");
        });
      }
      if ($req_cl_cc.val()) {
        view.getTerms($req_cl_cc, function() {
          var $sel = $('#' + $($req_cl_cc).data('select'));
          $sel.find("> [value='" + $sel.data('value') + "']").attr("selected", "true");
        });
      }
      if ($req_cl_bcc.val()) {
        view.getTerms($req_cl_bcc, function() {
          var $sel = $('#' + $($req_cl_bcc).data('select'));
          $sel.find("> [value='" + $sel.data('value') + "']").attr("selected", "true");
        });
      }

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
      DSP.setFieldOptions();
      DSP.setSelectOptions();
      $('.js-float-label-wrapper').FloatLabel();
      $('#previous').attr('href', '#identity');
      DSP.afterRender(view.pageName);
      return this;
    },

    getTerms: function(obj, callback) {
      var $th = $(obj), field = $th.prop('id'), select_field = $th.data('select');
      if ($th.val().length > 2) {
        var data = {id: DSP.id, ut: DSP.ut, requested_amount: $th.val(), field: field, select: select_field};
        //console.log('calling getTerms:', data);
        $('#' + data.select).prop('disabled', 'disabled');
        $("body").css("cursor", "progress");
        $('#error_' + field).html('').addClass('hidden');
        DSP.controller.getTerms(data, function (results, event) {
          console.log('remoteMethod getTerms:', results, 'event:', event);
          if (event.status) {
            if (results === null) {
              alert('no response from server');
            } else {
              //console.log('results:', results);
              if (results['error_' + field]) {
                $('#error_' + field).html(results['error_' + field].replace("\n", "<br/>")).removeClass('hidden');
              }
              if (data.select) {
                $('#' + data.select).empty()
                    .append($('<option></option>').val('').html('Select Term'));
                if (results.termList) {
                  var list = results.termList.split(';').sort();
                  console.log('terms list:', list);
                  for (i = 0; i < list.length; i++) {
                    $('<option/>').val(list[i]).html(list[i] + ' Months').appendTo('#' + data.select);
                  }
                }
                $('#' + data.select).prop('disabled', false);
              }
              $("body").css("cursor", "default");
            }
            if (typeof callback === "function") {
              callback();
            }
          } else {
            alert('could not contact server');
          }
        });
      }
    },

    vYearChange: function(obj, callback) {
      var view = this;
      view.$vmake.prop('disabled', 'disabled');
      $("body").css("cursor", "progress");
      DSP.controller.bringVehicleMakes($(obj).val(), function (results, event) {
        console.log('bringVehicleMakes:', results);
        if (event.status) {
          if (results === null) {
            alert('no response from server');
          } else {
            //console.log(results);
            view.$vmake.empty()
                .append($('<option></option>').val('').html('Select Make'));
            for (i = 0; i < results.length; i++) {
              $('<option/>').val(results[i]).html(results[i]).appendTo('#vehiclemake__c');
            }
            view.$vmodel.empty()
                .append($('<option></option>').val('').html('Select Model'));
            view.$vsubmodel.empty()
                .append($('<option></option>').val('').html('Select SubModel'));
            view.$vmake.prop('disabled', false);
            $("body").css("cursor", "default");
          }
        } else {
          alert('could not contact server');
        }
        if (typeof callback === "function") {
          callback();
        }
      });
    },

    vMakeChange: function(obj, callback) {
      var view = this;
      view.$vmodel.prop('disabled', 'disabled');
      $("body").css("cursor", "progress");
      DSP.controller.bringVehicleModels(view.$vyear.val(), $(obj).val(), function (results, event) {
        console.log('bringVehicleModels:', results);
        if (event.status) {
          if (results === null) {
            alert('no response from server');
          } else {
            //console.log(results);
            view.$vmodel.empty()
                .append($('<option></option>').val('').html('Select Model'));
            for (i = 0; i < results.length; i++) {
              $('<option/>').val(results[i]).html(results[i]).appendTo('#vehiclemodel__c');
            }
            view.$vsubmodel.empty()
                .append($('<option></option>').val('').html('Select SubModel'));
            view.$vmodel.prop('disabled', false);
            $("body").css("cursor", "default");
          }
        } else {
          alert('could not contact server');
        }
        if (typeof callback === "function") {
          callback();
        }
      });
    },

    vModelChange: function(obj, callback) {
      var view = this;
      view.$vsubmodel.prop('disabled', 'disabled');
      $("body").css("cursor", "progress");
      DSP.controller.bringVehicleSubModels(view.$vyear.val(), view.$vmake.val(), $(obj).val(), function (results, event) {
        console.log('remoteMethod bringVehicleSubModels:', results, 'event:', event);
        if (event.status) {
          if (results === null) {
            alert('no response from server');
          } else {
            view.$vsubmodel.empty()
                .append($('<option></option>').val('').html('Select SubModel'));
            for (i = 0; i < results.length; i++) {
              $('<option/>').val(results[i]).html(results[i]).appendTo('#vehicle_sub_model__c');
            }
            view.$vsubmodel.prop('disabled', false);
            $("body").css("cursor", "default");
          }
        } else {
          alert('could not contact server');
        }
        if (typeof callback === "function") {
          callback();
        }
      });
    }
  });

  return AccountDetailsPage;
});
