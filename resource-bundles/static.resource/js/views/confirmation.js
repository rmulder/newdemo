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
  'text!templates/confirmation.html'
], function($, _, Backbone, Force, forcetk, bootstrap_datepicker, moment, hbs, validate, vmethods, floatlabel, jquery_datetime, dsp, dspc, appTemplate, pageTemplate){

  var ConfirmationPage = Backbone.View.extend({

    el: '.container-fluid .form-contents',
    eld: '.container-fluid .disclosures',
    form: 'body#confirmation form',

    template: hbs.compile(appTemplate),
    templatep: hbs.compile(pageTemplate),
    templated: '',

    events:{
      //'click .myButton': 'submit'
    },

    submitHandler: function() {
      var view = this, $form = $(this.form);
      //console.log('submitHandler for :', view.pageName, 'next:', 'thank-you', 'form:', $form);
      $form.validate();
      $form.data('submitted', false);
      $form.submit(function() {
        if (DSP.currentPage == view.pageName) {
          //console.log('currentPage:' + DSP.currentPage + '; view:' + view.pageName);
          //alert('submitHandler for ' + view.pageName + '- currentPage:' + DSP.currentPage);
          //console.log('submitHandler.submit called for :', view.pageName, 'next:', 'thank-you');
          if ($form.data("validator").valid()) {
            //$form.data('submitted', true);
            $form.find('input').trigger('reset');
            //$form.off();
            //console.log('form:', $form);
            DSP.remotePostMethod($(view.form), view.pageName, 'thank-you');
          }  
           }
        return false;
      });
    },

    /*
    submit: function(e) {
      e.preventDefault();
      console.log('data:', $('form').serialize());
      Backbone.history.navigate("verify-identity", true);
    },
    */

    initialize: function(options) {
      $.extend(this, options);
      var view = this;
      clearTimeout(DSP.timeout1);
      clearTimeout(DSP.timeout2);
      clearTimeout(DSP.timeout3);
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
      $("body").attr("id","confirmation");
      $(this.el).html(this.template(DSP.models));
      $(this.eld).html(this.templated);
      $("#form-contents").html(view.templatep(DSP.models) );
    },

    reRender: function () {
      var view = this, products_list;
      $('body').append('<div id="tmp-content" class="hidden">' + view.templatep(DSP.models) + '</div>');
      products_list = $('#tmp-content #products-list').html();
      $('#tmp-content').remove();
      this.renderView();
      /* date time picker*/
      DSP.dateTimeDetection();
      view.submitHandler();
      $('input[type="radio"]').click(function () {
        var imgurl = DSP.custom_resources_url + "images/carddesign" + $(this).val() + '.jpg';
        $('#imagedest').html("<img src='" + imgurl + "'>");
      });

      if ($("input[type='radio']:checked").val() === undefined) {
        $('#firstCardId').prop('checked', true);
      }

      $('.nextStep').text('Finish');

      $('.modal-footer button.myButton').click(function (e) {
        e.preventDefault();
        var cardValue = $("input[type='radio']:checked").val(), data = {id: DSP.id, ut: DSP.ut};
        if (cardValue == 1) {
          //console.log('firstCard');
          data.cardSelected = 'firstCard';
        } else {
          //console.log('secondCard');
          data.cardSelected = 'secondCard';
        }
        DSP.controller.saveCardValue(data, function (results, event) {
          if (event.status) {
            if (results === null) {
              Backbone.history.navigate("session-expired", true);
              return false;
            } else {
              //console.log('saveCardValue results:', results);
            }
          } else {
            alert('could not contact server');
          }
          window.location.reload();
        });
        $('#chooseCardModal').modal('hide')
        $('.modal-backdrop').removeClass('in');
      });

      if ($(".selected_card_design").val() !== '') {
        if ($(".selected_card_design").val() === 'Standard Platinum Rewards') {
          $('#firstCardId').prop('checked', true);
        } else {
          $('#secondCardId').prop('checked', true);
        }
      } else {
        $('#firstCardId').prop('checked', true);
      }
      $("body").css("cursor", "default");
      $('.schedule-appt').click(function(e) {
        DSP.previous(e, view.form, view.pageName, function() {
          Backbone.history.navigate("schedule", true);
        });
      });
      DSP.setFieldOptions();
      DSP.setSelectOptions();
      $('.js-float-label-wrapper').FloatLabel();
      DSP.afterRender(view.pageName, products_list);
      return this;
    }

  });
  return ConfirmationPage;
});
