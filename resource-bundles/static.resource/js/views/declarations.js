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
  'text!templates/declarations.html'
], function($, _, Backbone, Force, forcetk, bootstrap_datepicker, moment, hbs, validate, vmethods, floatlabel, jquery_datetime, dsp, dspc, appTemplate, pageTemplate){

  var DeclarationsPage = Backbone.View.extend({

    el: '.container-fluid .form-contents',
    eld: '.container-fluid .disclosures',
    form: 'body#declarations form',

    template: hbs.compile(appTemplate),
    templatep: hbs.compile(pageTemplate),
    templated: '',

    products_list: undefined,

    events:{
      //'click button[type=submit].myButton': 'submit',
      'click body#declarations #previous': 'prev',
    },

    submitHandler: function() {
      var view = this, $form = $(this.form);
      $form.validate();
      $form.data('submitted', false);
      $form.submit(function() {
        if (DSP.currentPage == view.pageName) {
          if ($form.data("validator").valid() && $form.data('submitted') !== true) {
            $form.find('input,textarea').trigger('reset');
            DSP.remotePostMethod($(view.form), view.pageName, 'review-submit');
          }
        }
        return false;
      });
    },

    prev: function(e) {
      DSP.previous(e, this.form, this.pageName);
    },

    submit: function(e) {
      e.preventDefault();
      DSP.remotePostMethod($(this.form), this.pageName, 'review-submit');
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
      $("body").attr("id","declarations");
      $(this.el).html(this.template(DSP.models));
      $(this.eld).html(this.templated);
      view.products_list = $('#tmp-content #products-list').html();
      $('#tmp-content').remove();
      $("#form-contents").html(view.templatep(DSP.models) );
      //productResult_dec = DSP.models.Application2__c.hmda_info_pa__c;
      //console.log(productResult_dec);
      /*if(productResult_dec == 'true'){
        $('#hmda_info_pa__c').prop('checked', true);
      }
      else {
         $('#hmda_info_pa__c').prop('checked', false);
      } */
    },

    reRender: function () {
      var view = this;
      this.renderView();
      view.submitHandler();
      $('.formFields[id*=Decl]').each(function() {
        var $th = $(this);
        if ($th.data('value') !== '') {
          $th.find('input[type=radio][value="' + $th.data('value') + '"]').attr('checked', 'checked');
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
      /* date time picker*/
      $('.datepicker1').datetimepicker();

      $('div.formFields[id*=appDecl]').each(function() {
        var $th = $(this);
        $th.find('input[type="radio"]').not('.1_1').click(function() {
          var val = $(this).val(), $ta = $th.find('textarea');
          if (val === 'true') {
            $ta.parent().removeClass('hide');
          } else {
            $ta.parent().addClass('hide');
          }
        });
      });

      $('.perm-resident input[type=radio]').on('click', function () {
        var id = $(this).closest('.formFields').attr('id');
        if ($(this).val() === 'No') {
          $('#' + id + '_2').removeClass('hidden');
        } else {
          $('#' + id + '_2').addClass('hidden');
        }
      });

      $('.ownership-interest input[type=radio]').on('click', function () {
        if ($(this).val() === 'true') {
          $(this).closest('.formFields').find('.ownership-interest-details').removeClass('hidden');
        } else {
          $(this).closest('.formFields').find('.ownership-interest-details').addClass('hidden');
        }
      });

      $('input[type=radio]:checked').each(function (indx, el) {
        el.click();
      });

      $('input[type=radio]').each(function () {
        $(this).rules('add', {
          required: true,
          messages: {
            required: "Select an option"
          }
        });
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
      $('input[class*=hamdaNoDecl]').each(function() {
        var $th = $(this);
        if ($th.data('value') == true) {
          $th.prop('checked', true);
        } else {
          $th.prop('checked', false);
        }
      });
      $('.js-float-label-wrapper').FloatLabel();
      $('#previous').attr('href', '#property-details');
      DSP.afterRender(view.pageName, view.products_list);
      return this;
    }

  });

  return DeclarationsPage;
});
