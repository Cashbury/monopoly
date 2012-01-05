jQuery(function($) {
    $('#place_business_id').change(function(e) {
	var value = e.target.value;
	if (value != '') {
	    $.get('/businesses/'+value+'/country_code' , undefined, function(e) {
		var code = e['country_code'];
		$('.code').html(code);
	    });
	}
	else {
	    $('.code').html('');
	}
    });
});
