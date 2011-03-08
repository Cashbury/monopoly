$(function () {  
  $('#reports th a').live('click', function () {  
    $.getScript(this.href);  
    return false;  
  });  

  $('a#CB-qrcode-multiple').click(function(e){
    alert("test"); 
    return false;
  })
})

function change_engagement_status(id)
{
	$.ajax({
  	type: 'POST',
  	url: "/engagements/"+id+"/change_status",
		success: function(){
			if($('#current_status_'+id).text()=="stopped"){
				$('#status_'+id).text("Stop");
				$('#current_status_'+id).text("started");
			}
			else{
				$('#status_'+id).text("Start");
				$('#current_status_'+id).text("stopped");
			}
  	}
	});
}
