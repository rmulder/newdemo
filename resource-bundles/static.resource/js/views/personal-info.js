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
  'bootstrap_datepicker',
  'moment',
  'Backbone.Force',
  'forcetk.ui',
  'Handlebars',
  'jquery.validate',
  'jquery.validate.methods',
  'jquery.floatlabel',
  'jquery_datetime',
  'dsp',
  'dsp.common',
  'text!templates/application.html',
  'text!templates/personal-info.html'
], function($, _, Backbone, bootstrap_datepicker, moment, Force, forcetk, hbs, validate, vmethods, floatlabel, jquery_datetime, dsp, dspc, appTemplate, pageTemplate){

  var PersonalInfoPage = Backbone.View.extend({

    el: '.container-fluid .form-contents',
    eld: '.container-fluid .disclosures',
    form: 'body#personal-info form',

    template: hbs.compile(appTemplate),
    templatep: hbs.compile(pageTemplate),
    templated: '',

    events:{
      'click body#personal-info #previous': 'prev'
    },

    submitHandler: function() {
      var view = this, $form = $(this.form);
      $form.validate().resetForm();
      $form.data("validator").addCustomValidations(['firstName', 'middleName', 'lastName', 'durationYears', 'durationMonths', 'phoneUS', 'zipcodeUS', 'currencyUS', 'routingNumber']);
      $form.data('submitted', false);
      $form.submit(function() {
        if (DSP.currentPage == view.pageName) {
          if ($form.data("validator").valid() && $form.data('submitted') !== true) {
            $form.find('input').trigger('reset');
            DSP.remotePostMethod($j(view.form), view.pageName, 'employment');
          }
        }
        return false;
      });
    },

    prev: function(e) {
      alert('called prev from personal-info');
      $(this.form).off();
      DSP.previous(e, this.form, this.pageName);
    },

    initialize: function(options) {
      $.extend(this, options);
      var view = this;
      view.render();
      $("body").css("cursor", "progress");
      DSP.remoteMethod(this.pageName, null, function(results) {
        view.reRender();
        //$("#form-contents").html(view.templatep(DSP.models));
      });
    },

    render: function() {
      hbs.registerPartial("form-contents", this.templatep(DSP.models));
      //console.log('personal-info templatep DSP.models:', DSP.models);
      $('body').append('<div id="tmp-content" class="hidden">'+this.templatep(DSP.models)+'</div>');
      hbs.registerPartial("header-contents", $('#tmp-content #header-contents').html());
      hbs.registerPartial("action-panel", $('#tmp-content #action-panel').html());
      this.templated = $('#tmp-content #disclosures').html();
      $('#tmp-content').remove();
      $("body").attr("id","personal-info");
      //console.log('personal-info:', DSP.models);
      $(this.el).html(this.template(DSP.models));
      $(this.eld).html(this.templated);
      //$('.js-float-label-wrapper').FloatLabel();
      return this;
    },

    reRender: function() {
      var view = this, products_list;
      var add_arr = [], tmpobj; //array to keep track of applicants that are being added
      for (var i = 1; i < 4; i++) {
        tmpobj = {
          i: i,
          j: (i+1)
        };
        add_arr.push(tmpobj);
      }

      $(this.el).html(this.template(DSP.models));
      $(this.eld).html(this.templated);
      $('body').append('<div id="tmp-content" class="hidden">' + view.templatep(DSP.models) + '</div>');
      products_list = $('#tmp-content #products-list').html();
      //console.log('products-list:', $('#tmp-content #products-list').html());
      $('#tmp-content').remove();
      $("#form-contents").html(view.templatep(DSP.models) );
      //Adding and removing applicants
      $.each(add_arr, function () {
        var th = this, $current = $('.add_link_'+th.i);
        $current.click(function() {
          //console.log('current:', $current, 'this:', th);
          var $ck = $current.parent().find('input[type=checkbox]');
          $ck.prop('checked', true);
          $ck.val(true);
          /*if ($ck.prop('checked') == false) {
            $ck.trigger('click');
          } */

          $('#appl_'+th.j+',#addApplicantLink_'+th.j).removeClass('hide').show();
          $('#appl_'+th.j)
              .find('.phoneUS, .email, .appl_'+th.j+'_relationshipToPrimary')
              .addClass('required')
              .end()
              .find('#appl_' + th.j + '_nameAdd .firstName,.lastName,.appl_' + th.j + '_address1,.appl_' + th.j +
                  '_city,.appl_' + th.j+'_state,.appl_'+th.j+'_zipcode,' + '.appl_' + th.j + '_housingstatus,.appl_' +
                  th.j + '_annualIncome,.durationYears,.durationMonths,.appl_' + th.j + '_maritalStatus')
              .addClass('required').end()
              .find('input[type=text],select').trigger('focus').end()
              .find('#appl_' + th.j + '_nameAdd .firstName').trigger('focus');
        });

        $('.remove_link_'+th.j).click(function(){
          //alert('i:'+th.i+'; j:'+th.j);
          $('#appl_'+th.j+',#addApplicantLink_'+th.j).addClass('hide').hide();
          $('#appl_'+th.i+',#addApplicantLink_'+th.i).removeClass('hide').show();
          $('.add_link_'+th.i+'_checkbox').prop('checked', false);
          $('#appl_'+th.j)
              .find('.phoneUS, .email')
              .removeClass('required')
              .end()
              .find('#appl_' + th.j + '_nameAdd .firstName,.lastName,.appl_' + th.j + '_address1,.appl_' + th.j +
                  '_city,.appl_' + th.j + '_state,.appl_' + th.j + '_zipcode,.appl_' + th.j + '_housingstatus,.appl_' +
                  th.j + '_annualIncome,.durationYears,.durationMonths,.appl_' + th.j + '_maritalStatus')
              .removeClass('required')
              .end()
              .find('input[type=text],select').val('');
        });
      });

      $('[class*="copy_prime_address"]').click(function () {
        var $th = $(this), className = $th.attr('class'), appl = className.substr(19);
        if ($th.is(':checked')) {
          $(".appl_" + appl + "_address1").val($(".appl_1_address1").val());
          $(".appl_" + appl + "_address2").val($(".appl_1_address2").val());
          $(".appl_" + appl + "_city").val($(".appl_1_city").val());
          $(".appl_" + appl + "_state").val($(".appl_1_state").val());
          $(".appl_" + appl + "_zipcode").val($(".appl_1_zipcode").val());
        } else {
          $(".appl_" + appl + "_address2").val('').trigger('focus');
          $(".appl_" + appl + "_city").val('').trigger('focus');
          $(".appl_" + appl + "_state").val('').trigger('focus');
          $(".appl_" + appl + "_zipcode").val('').trigger('focus');
          $(".appl_" + appl + "_address1").val('').trigger('focus');
        }
      });

      $('.durationYears').keyup(function () {
        var $th = $(this), parentDiv = $th.closest('.formFields'), siblingDiv = parentDiv.siblings('.previousAddress');
        //console.log('parent:', parentDiv, 'siblings:', siblingDiv);
        if ($th.val() <= 1) {
          //alert($th.val());
          $(siblingDiv).show();
          $(siblingDiv).removeClass('hide');
        } else {
          $(siblingDiv).hide();
          $(siblingDiv).addClass('hide');
          $(siblingDiv).find('input').each(function() {
            $(this).val('').trigger('blur');
          });
          //$('#appl_2_previousAdd').hide('slow');
          //$('.appl_1_prevAdd1_c').val("");
          //$('.appl_1_prevAdd2_c').val("");
        }
      });
      $('.durationYears').each(function() {
        var $th = $(this);
        if ($th.val()) {
          $th.trigger('keyup');
        }
      });
      view.submitHandler();
      DSP.dateTimeDetection();
      $('input[type=checkbox]').each(function() {
        var $th = $(this);
        if ($th.data('value')) {
          $th.prev().trigger('click');
          $th.attr('checked', 'checked').trigger('click');
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
      $("body").css("cursor", "default");
      DSP.setFieldOptions();
      DSP.setSelectOptions();
      $('.js-float-label-wrapper').FloatLabel();
      DSP.afterRender(view.pageName, products_list);
      $('#header-logo').addClass('hidden');
      $('#previous').attr('href', '#cross-sell');
      return this;
    }
  });
  return PersonalInfoPage;
});
