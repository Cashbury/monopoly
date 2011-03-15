jQuery.noConflict();
jQuery(function () {  
  jQuery('#reports th a').live('click', function () {  
    jQuery.getScript(this.href);  
    return false;  
  });  

  jQuery('a#CB-qrcode-multiple').click(function(e){
    alert("test"); 
    return false;
  })
  jQuery("select#filters_business_id").change(function(){
		var id_value_string = jQuery(this).val();
		if (id_value_string == "") { 
			jQuery("select#filters_place_id option").remove();
			var row = "<option value=\"" + "" + "\">" + "-- Place --" + "</option>";
     	jQuery(row).appendTo("select#filters_place_id");
		}
		else { 
			jQuery.ajax({
				dataType: "json",
        cache: false,
        url: '/places/for_businessid/' + id_value_string,
        timeout: 2000,
				error: function(XMLHttpRequest, errorTextStatus, error){
					alert("Failed to submit : "+ errorTextStatus+" ;"+error);
				},
				success: function(data){                     
					jQuery("select#filters_place_id option").remove();
					var row = "<option value=\"" + "" + "\">" + "-- Place --" + "</option>";
          jQuery(row).appendTo("select#filters_place_id");                         
        	jQuery.each(data, function(i, j){
						row = "<option value=\"" + j.place.id + "\">" + j.place.name + "</option>";   
		      	jQuery(row).appendTo("select#filters_place_id");                     
					});             
				}
			});
		};
	});
})

function change_engagement_status(id)
{
	jQuery.ajax({
  	type: 'POST',
  	url: "/engagements/"+id+"/change_status",
		success: function(){
			if(jQuery('#current_status_'+id).text()=="stopped"){
				jQuery('#status_'+id).text("Stop");
				jQuery('#current_status_'+id).text("started");
			}
			else{
				jQuery('#status_'+id).text("Start");
				jQuery('#current_status_'+id).text("stopped");
			}
  	}
	});return false;
}

var submitUsersSnapsSearch = function(form, sortingBy, page, direction){
	businessId = (jQuery('select#filters_business_id').val() == "") ? 0 : jQuery('select#filters_business_id').val();
	placeId    = (jQuery('select#filters_place_id').val()=="") ? 0 : jQuery('select#filters_place_id').val();
	startDate  = (jQuery('#filters_start_date').val()=="") ? 0 : jQuery('#filters_start_date').val();
	endDate    = (jQuery('#filters_end_date').val()=="")? 0 : jQuery('#filters_end_date').val();
	window.location = "/users_snaps/businesses/" + businessId + "/places/" + placeId + "/start_date/" + startDate + "/end_date/"+ endDate;
}