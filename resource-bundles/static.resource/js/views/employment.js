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
  'autocomplete',
  'text!templates/application.html',
  'text!templates/employment.html'
], function($, _, Backbone, Force, forcetk, bootstrap_datepicker, moment, hbs, validate, vmethods, floatlabel, jquery_datetime, dsp, dspc, autoc, appTemplate, pageTemplate){

  var EmploymentPage = Backbone.View.extend({

    el: '.container-fluid .form-contents',
    eld: '.container-fluid .disclosures',
    form: 'body#employment form',

    template: hbs.compile(appTemplate),
    templatep: hbs.compile(pageTemplate),
    templated: '',

    events:{
      'click body#employment #previous': 'prev'
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
            DSP.remotePostMethod($(view.form), view.pageName, 'identity');
          }
        }
        return false;
      });
    },

    prev: function(e) {
      alert('called prev from employment');
      $(this.form).off();
      DSP.previous(e, this.form, this.pageName);
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

    checkName: function(employmentName, divNumber) {
      DSP.controller.checkCompany(employmentName, function(result, event) {
        //console.log('event:', event, 'result:', result, 'divNumber:', divNumber);
        if (event.status) {
          if (result){
            $('#EmployerCompany' + divNumber).hide();
          } else {
            $('#EmployerCompany' + divNumber).show();
          }
        }else{
          alert('problem contacting server')
        }
      });
    },

    setEmploymentFields: function(val, div) {
      if (val === 'Retired' || val === 'Unemployed') {
        $('#employerName_' + div).hide();
        $('#prior_occupation_' + div).removeClass('hidden');
        $('#occupation_' + div).addClass('hidden');
        $('#time_employed_' + div).addClass('hidden');
      } else {
        $('#employerName_' + div).show();
        $('#occupation_' + div).removeClass('hidden');
        $('#prior_occupation_' + div).addClass('hidden');
        $('#time_employed_' + div).removeClass('hidden');
      }
    },

    render: function() {
      this.renderView();
      $('.js-float-label-wrapper').FloatLabel();
      return this;
    },

    renderView: function() {
      var view = this;
      hbs.registerPartial("form-contents", this.templatep(DSP.models));
      $('body').append('<div id="tmp-content" class="hidden">'+this.templatep(DSP.models)+'</div>');
      hbs.registerPartial("header-contents", $('#tmp-content #header-contents').html());
      hbs.registerPartial("action-panel", $('#tmp-content #action-panel').html());
      this.templated = $('#tmp-content #disclosures').html();
      $('#tmp-content').remove();
      $("body").  attr("id","employment");
      $(this.el).html(this.template(DSP.models));
      $(this.eld).html(this.templated);
      $("#form-contents").html(view.templatep(DSP.models) );
    },

    reRender: function() {
      var view = this, products_list;
      this.renderView();
      $('body').append('<div id="tmp-content" class="hidden">' + view.templatep(DSP.models) + '</div>');
      products_list = $('#tmp-content #products-list').html();
      $('#tmp-content').remove();
      $('input[class*=currentEmployerYears]').each(function () {
        var $th = $(this), parts = $th.attr('class').split('_');
        if (parseInt($th.val()) <= 1) {
          $('#appl_' + parts[1] + '_previousEmployer').slideDown('slow')
        }

        $th.keyup(function() {
          if (parseInt($(this).val()) <= 1) {
            $('#appl_' + parts[1] + '_previousEmployer').slideDown('slow').removeClass('hide');
          } else {
            $('#appl_' + parts[1] + '_previousEmployer').hide('slow');
          }
        });

        if ($th.val()) {
          $th.trigger('keyup');
        }
      });

      if ($(this).hasClass('delete_other_income')) {
          $current.find('select').val('');
          $current.find('input[type=text]').val('');
          $current.addClass('hidden').css('display', 'none');
          //alert("inside delete");
      }
/*
      $('input[name*=employer_]').each(function(){
        $(this).attr('list', 'companyList');
      });
*/      $(".otherIncome").on('change', function() {
        if($(".otherIncome").val () === 'Other Income') {
            this.addClass("required");
        }
        });
      DSP.dateTimeDetection();
      $('select[name*=employment_status]').each(function () {
        var $th = $(this), parts = $th.closest('.formFields').attr('id').split('_');
        //console.log('select[name*=employment_status]', $th, parts, 'val:', $th.val());
        view.setEmploymentFields($th.val(), parts[1]);
        $th.change(function () {
          view.setEmploymentFields($(this).val(), parts[1]);
        });
      });

      var add_del_arr = [], tmpobj;
      for (var j = 1; j < 6; j++) {
        for (var i = 1; i < 5; i++) {
          tmpobj = {
            selector: 'appl_'+i+'_otherIncomeBlock'+ j,
            prev: 'appl_'+i+'_otherIncomeBlock'+ (j-1),
            next: 'appl_'+i+'_otherIncomeBlock'+ (j+1)
          };
          add_del_arr.push(tmpobj);
        }
      }

      $.each(add_del_arr, function () {
        var th = this, $current = $('#'+th.selector);
        $current.find('a').each(function () {
          //console.log(th);
          if ($(this).hasClass('add_other_income')) {
            //console.log('selector:', th.selector, '; next:', th.next);
            $(this).on('click', function () {
              //console.log('next:', $('#'+th.next));
              $('#'+th.next).removeClass('hidden').css('display', 'block');
            });
          }
          if ($(this).hasClass('delete_other_income')) {
            //console.log('selector:', th.selector, '; prev:', th.prev);
            $(this).on('click', function () {
              //console.log($('#'+th.selector));
              $current.find('select').val('');
              $current.find('input[type=text]').val('');
              $current.addClass('hidden').css('display', 'none');
            });
          }
        });
        $current.find('select').each(function () {
          if ($(this).val()) {
            $current.removeClass('hidden').css('display', 'block');
          }
          $(this).on('change', function () {
            if ($(this).val() === '') {
              $current.find('input[class*=currencyUS]').removeClass('required');
              $(this).removeClass('required');
            } else {
              $current.find('input[class*=currencyUS]').addClass('required');
            }
          });
        });
      });

      //code for the other income validation
      var appl_array = []; tmpobj;
      for (var m = 1; m < 5; m++) {
        tmpobj = {
          m: m
        };
        appl_array.push(tmpobj);
      }
      $.each(appl_array,function() {
        var th = this;
        $('.otherIncome'+th.m).find('.income').keyup(function() {
          if ($(this).val() === "" || $(this).val() === "0.00") {
            $('.otherIncome'+th.m).find(".otherIncome").removeClass("required");
          } else {
            $('.otherIncome'+th.m).find(".otherIncome").addClass("required");
          }
          if ($('.otherIncome'+th.m).find(".otherIncome").val() !== "") {
            $(this).addClass("required");
          }
        });
        $('.otherIncome'+th.m).find('.otherIncome').on('change', function() {
          if ($('.otherIncome'+th.m).find('.income').val () !== "" && $(this).val() === "") {
            $(this).addClass("required");
          }
        });
      });

      var inc_array = []; incobj = {};
      for(j=1; j<5; j++) {               //loops through the 4 applicants
        for (var n=2;n<6;n++) {                //loops through 4 additional incomes
          incobj = {
            j: j,
            n: n
          };
          inc_array.push(incobj);
        }
      }
      $.each(inc_array, function() {
        var th = this;
        $('.otherIncome'+th.j+'_'+th.n).find('.income').keyup(function() {
          if ($(this).val() === "" || $(this).val() === "0.00") {
            $('.otherIncome'+th.j+'_'+th.n).find(".otherIncome").removeClass("required");
          } else {
            $('.otherIncome'+th.j+'_'+th.n).find(".otherIncome").addClass("required");
          }
          if ($('.otherIncome'+th.j+'_'+th.n).find(".otherIncome").val() !== "") {
            $(this).addClass("required");
          }
        })
        $('.otherIncome'+th.j+'_'+th.n).find('.otherIncome').on('change', function() {
          if ($('.otherIncome'+th.j+'_'+th.n).find('.income').val() !== "" && $(this).val() === "") {
            $(this).addClass("required");
          }
        });
      });

      view.submitHandler();
      $('input[type=radio]').each(function() {
        $(this).rules('add', {
          required: true,
          messages: {
            required: "Select an option"
          }
        });
      });

      $('.member_title').each(function() {
        $(this).find('input[type=radio][value="' + $(this).data('value') + '"]').prop('checked', true);
      });

      if (DSP.models.DisplayedFields && DSP.models.DisplayedFields.EmployerAutocompleteSection) {
        /*
         DSP.controller['getCompanyList'](function(result, event) {
         if (event.status) {
         try {
         //console.log('event:', event, 'result:', result);
         var aListCon = $('.aListCon'),
         dl = $('<datalist/>').attr('id', 'employerList1').appendTo(aListCon);
         $('<!--[if IE 9]><select disabled="disabled"><![endif]-->').appendTo(dl);
         //console.log(aListCon);
         $.each(result, function(idx, el) {
         //console.log(el);
         $('<option/>').val(el).html(el).appendTo(dl);
         });
         $('<!--[if IE 9]></select><![endif]-->').appendTo(dl);
         } catch(e) {
         alert('Exception!');
         console.log(e);
         }
         }else{
         alert('problem contacting server')
         }
         });
         */
        //$('input[name*=employer_]').each(function() {
        //console.log('employer', this);
        //});
        
        // Autocomplete setup:
        $('.employerName>input[type=text]').each(function () {
          // Activate the search box typeahead
          var n = navigator.userAgent.toLowerCase(), th = this, myAutocomplete,
              offset = (/msie/.test(n)) && (!/opera/.test(n)) ? -$(this).outerWidth() : 0;
          myAutocomplete = new Autocomplete(this, {
            useNativeInterface : false,
            offsetLeft: offset,
            srcType : "dom",
            onInputDelay : 0,
            onInput : function(newValue, oldValue){
              var $parent = $(th).parent(), parts = $parent.prop('id').split('_');

              if (parts[1]) {
                view.checkName(newValue, parts[1]);
              }
            }
          });
        });
        $('.empName').on('keypress blur focus', function(e) {
          var $input = $(this),
              $parent = $input.parent(),
              parts = $parent.prop('id').split('_');

          if (parts[1]) {
            view.checkName($input.val(), parts[1]);
          }
        });
        $('.empName').each(function() {
          $(this).trigger('blur');
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
      /* date time picker*/
      $("body").css("cursor", "default");
      DSP.setFieldOptions();
      DSP.setSelectOptions();
      $('.js-float-label-wrapper').FloatLabel();
      $('#previous').attr('href', '#personal-info');
      DSP.afterRender(view.pageName, products_list);
      return this;
    }

  });

  return EmploymentPage;
});
