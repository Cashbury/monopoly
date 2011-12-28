jQuery(function($) {

    $('[name=working_hours]').click(function(e) {
        var target = e.target;
        if (target.value == 'defined') {
            $('.business_hours').show();
        }
        else {
            $('.business_hours').hide();
            $('.close').each(function(i, close) {
                set_day_closed(close, true);
            } );
        }
    });

    $('.close').click(function(e) {
        var target = e.target;
        set_day_closed(target, target.checked);
    });

    $('.split').click(function(e) {
        var target = e.target;
        var $dow = $(target).closest('.dow');
        if (target.checked) {
            $dow.find('.split_time').show();
        }
        else {
            $dow.find('.split_time').hide();
        }
        var closed = $dow.find('.close')[0].checked;
        if (closed) {
            $dow.find('select').attr('disabled', 'disabled');
        }
        else {
            $dow.find('select').removeAttr('disabled');
        }
    });

    function set_day_closed(checkbox, closed) {
        checkbox.checked = closed;
        if (closed) {
            $(checkbox).closest('.dow').find('select').
                attr('disabled', 'disabled');
        }
        else {
            $(checkbox).closest('.dow').find('select:visible').
                removeAttr('disabled');
        }
    }

});
