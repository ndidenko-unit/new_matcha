// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.atwho
//= require jquery_ujs
//= require bootstrap
//= require bindWithDelay
//= require moment.min
//= require fullcalendar.min
//= require jquery.datetimepicker
//= require_tree .

$(document).ready(function () {
  $("#event_event_datetime").datetimepicker({format: 'Y/m/d H:i'});
  $("#user_dob").datetimepicker({timepicker: false, format: 'Y/m/d', maxDate: '0'});
});

(function() {
    $(document).on('click', '.toggle-window', function(e) {
        e.preventDefault();
        var panel = $(this).parent().parent();
        var messages_list = panel.find('.messages-list');

        panel.find('.panel-body').toggle();
        panel.attr('class', 'panel panel-default');

        if (panel.find('.panel-body').is(':visible')) {
            var height = messages_list[0].scrollHeight;
            messages_list.scrollTop(height);
        }
    });
})();
