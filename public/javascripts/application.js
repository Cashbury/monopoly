//jQuery.noConflict();
$(document).ready(function () {
  $('.datepicker').live('click', function () {
    $(this).datepicker({ dateFormat: 'yyyy-mm-dd' });
  }); 
  $('#reports th a').live('click', function () {
    $.getScript(this.href);
    return false;
  });

  $('a#CB-qrcode-multiple').click(function(e){
    alert("test");
    return false;
  })
  $("select#filters_business_id").change(function(){
		var id_value_string = $(this).val();
		if (id_value_string == "") {
			$("select#filters_place_id option").remove();
			var row = "<option value=\"" + "" + "\">" + "-- Place --" + "</option>";
     	$(row).appendTo("select#filters_place_id");
		}
		else {
			$.ajax({
				dataType: "json",
        cache: false,
        url: '/places/for_businessid/' + id_value_string,
        timeout: 2000,
				error: function(XMLHttpRequest, errorTextStatus, error){
					alert("Failed to submit : "+ errorTextStatus+" ;"+error);
				},
				success: function(data){
					$("select#filters_place_id option").remove();
					var row = "<option value=\"" + "" + "\">" + "-- Place --" + "</option>";
          $(row).appendTo("select#filters_place_id");
        	$.each(data, function(i, j){
						row = "<option value=\"" + j.place.id + "\">" + j.place.name + "</option>";
		      	$(row).appendTo("select#filters_place_id");
					});
				}
			});
		};
	});


	$('table.mono-table tr').each(function(i,d){
			 $(d).find('td:last').css({borderRight:'1px solid #ccc'});
			 $(d).find('th:last').css({borderRight:'1px solid #ccc'});
	});

  $('table.mono-table tr:last td').css({borderBottom:'1px solid #e2dfdf'});

  $(".open_sign").click(function(){return false});
      //jQuery.EnablePlaceholder.defaults.withPlaceholderClass = 'title';
      //jQuery('input[type=text]').enablePlaceholder();

})

function change_engagement_status(biz_id,prog_id,c_id,eng_id)
{
	$.ajax({
  	type: 'POST',
  	url: "/businesses/"+biz_id+"/programs/"+prog_id+"/campaigns/"+c_id+"/engagements/"+eng_id+"/change_status",
		success: function(){
			if($('#current_status_'+eng_id).text()=="false"){
				$('#status_'+eng_id).text("Stop");
				$('#current_status_'+eng_id).text("true");
			}
			else{
				$('#status_'+eng_id).text("Start");
				$('#current_status_'+eng_id).text("false");
			}
  	}
	});return false;
}

var submitUsersSnapsSearch = function(form,page){
	businessId = ($('select#filters_business_id').val() == "") ? 0 : $('select#filters_business_id').val();
	placeId    = ($('select#filters_place_id').val()=="") ? 0 : $('select#filters_place_id').val();
	fromDate  = ($('#filters_from_date').val()=="") ? 0 : $('#filters_from_date').val();
	toDate    = ($('#filters_to_date').val()=="")? 0 : $('#filters_to_date').val();
	window.location = "/users_snaps/businesses/" + businessId + "/places/" + placeId + "/from_date/" + fromDate + "/to_date/"+ toDate;
}

var submitLoyalCustomersSearch = function(form,page){
	businessId = ($('select#filters_business_id').val() == "") ? 0 : $('select#filters_business_id').val();
	placeId    = ($('select#filters_place_id').val()=="") ? 0 : $('select#filters_place_id').val();
	fromDate  = ($('#filters_from_date').val()=="") ? 0 : $('#filters_from_date').val();
	toDate    = ($('#filters_to_date').val()=="")? 0 : $('#filters_to_date').val();
	window.location = "/loyal_customers/businesses/" + businessId + "/places/" + placeId + "/from_date/" + fromDate + "/to_date/"+ toDate;
}

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  counter=counter+1;
  new_content=content.replace(/Offer Level [0-9]/,"Offer Level "+(counter+1));
  $(link).parent().before(new_content.replace(regexp, new_id));
  $(".reward_end_date").datepicker().trigger("change");
  $(".reward_exp_date").datepicker().trigger("change");
}
