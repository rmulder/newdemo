
(function (global) {

    'use strict';

    global.dspTimeout = function (token, seconds, popSeconds, refreshFunction, $, moment) {

        var timeoutAfter = seconds,//10 seconds
            intervalTime = 1000, //1 second
            active = true,
            since = 0,
            modalIntervalHandler,
            intervalFunction,
            intervalHandler,
            resetFunction,

            //resets initial timer if user has been active
            resetTimer = function () {
                clearInterval(modalIntervalHandler);
                $('#timeoutModal').modal('hide');
                timeoutAfter = seconds;
                intervalHandler = setInterval(intervalFunction, intervalTime);
                $('body').on('keypress', resetFunction).on('click', resetFunction);
                $(global.document).on('mousemove', resetFunction);
            },

            //converts a number of seconds to minutes:seconds format
            humanizeDuration = function (input) {
               
                var duration = moment.duration(input, 'seconds'),
                    minutes = duration.minutes(),
                    seconds = duration.seconds(),
                    timeString;

                if (seconds < 10) {
                    seconds = '0' + seconds;
                }

                timeString = minutes + ':' + seconds;

                return timeString;
            };

        //the function to call every interval
        intervalFunction = function () {

            timeoutAfter = timeoutAfter - 1;
            since = since + 1;

            if (timeoutAfter === 0) {
                //first timer has run out
                global.clearInterval(intervalHandler);

                var message = 'token:' + token,
                    secondsLeft;

                //if user inactivity time is less than timeout duration
                if (since < seconds) {
                    refreshFunction();
                    timeoutAfter = seconds;
                    intervalHandler = setInterval(intervalFunction, intervalTime);
                } else {

                    secondsLeft = popSeconds;

                    $('#secondsLeft').html(humanizeDuration(secondsLeft));

                    //countdown function for inside popup
                    modalIntervalHandler = setInterval(function () {
                        secondsLeft = secondsLeft - 1;
                        if (secondsLeft >= 0) {
                            $('#secondsLeft').html(humanizeDuration(secondsLeft));
                        } else {
                            global.clearInterval(modalIntervalHandler);
                            $('.modal-backdrop').removeClass('in').addClass('out');
                            $('#timeoutModal').modal(true).hide();
                            global.location = '#session-expired';
                        }
                    }, 1000);

                    //show modal and don't let user close it unless they click Continue
                    $('#timeoutModal').modal({'keyboard': true, 'backdrop': true});

                    //$('#timeoutModal').modal({ backdrop: 'static', keyboard: false }).modal('show');
                    $('body').off('keypress').off('click');
                    $(global.document).off('mousemove');
                }
            }
        };

        //set up the timer for user activity
        intervalHandler = setInterval(intervalFunction, intervalTime);
        var now = moment();
        //function to fire when the user is active
        resetFunction = function (e) {
            since = 0;
        };

        //watch body for keyboard activity
        $('body').on('keypress', resetFunction).on('click', resetFunction);

        //watch the mouse for user activity
        $(global.document).on('mousemove,scroll', resetFunction);

        $('#continueWorking').on('click', function (e) {
            refreshFunction();
            resetTimer();
        });
    };

}(this));