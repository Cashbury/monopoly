/*function Split_hour(index){
    from_to_html = $('#open_hour_'+index+'_from').parent().html();
    //from_to_html = from_to_html.replace(/from/g, "from2");
    //from_to_html = from_to_html.replace(/to/g, "to2");
    closed1_label ="<label class='hf closed '> Closed? </label>";
    closed2_checkbox_html = "<input class='hf closed ' type='checkbox' value='1' name='open_hour["+index+"][closed2]' />" ;
    final_html_part = from_to_html + closed1_label+closed2_checkbox_html ;
    $('#open_hour_div_'+index).append("<div>"+final_html_part+"</div><div class='clear'></div>");
    $('input.complete').autocomplete({source:sHours});

}
function Split_hour_admin(index){
    from_to_html="";
    from_to_html = $('#open_hour_'+index+'_from').closest("div.input_set").html();

    from_to_html = from_to_html.replace(/from/g, "from2");
    from_to_html = from_to_html.replace(/to/g, "to2");
    //closed1_label ="<label> Closed? </label>";
    //closed2_checkbox_html = "<input type='checkbox' value='1' name='open_hour["+index+"][closed2]' /><br/>" ;
    //final_html_part = from_to_html + closed1_label+closed2_checkbox_html ;
    $('#open_hour_div_'+index).append(from_to_html);
    $('input.complete').autocomplete({source:sHours});

}*/
function initialize() {
    var latlng = new google.maps.LatLng(-34.397, 150.644);
    var myOptions = {
      zoom: 8,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    myMap = new google.maps.Map($("#map_canvas")[0], myOptions);
    myMap2 = new google.maps.Map($("#my_map2")[0], myOptions);

    google.maps.event.addListener(marker,"dragend",function(){
        myMap.panTo(marker.getPosition());
        myMap2.panTo(marker.getPosition());
        $('input#city_lng,input#long, input#place_long').val(marker.getPosition().lng());
        $('input#city_lat,input#lat, input#place_lat').val(marker.getPosition().lat());

    });
    google.maps.event.addListener(marker2,"dragend",function(){
        myMap.panTo(marker2.getPosition());
        myMap2.panTo(marker2.getPosition());
        
        $('input#city_lat, input#lat, input#place_lat').val(marker2.getPosition().lat());
        $('input#city_lng, input#long, input#place_long').val(marker2.getPosition().lng());

    });
  }

  var MonoV1 = {
    find_place_on_map:function(strAddress){
      if(strAddress=="") return null;

      geocoder.geocode( { 'address': strAddress }, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
          place = results[0];
          marker.setDraggable(true);
          marker.setPosition(results[0].geometry.location);

          myMap.setZoom(17);
          myMap.setCenter(results[0].geometry.location);

          marker.setMap(myMap);

          if(typeof myMap2 !="undefined"){
            myMap2.setZoom(17);
            marker2.setDraggable(true);
            marker2.setPosition(place.geometry.location);
            myMap2.setCenter(place.geometry.location);
            marker2.setMap(myMap2);
          }
          R = [""];
          //R = results[0].formatted_address.split(',');
          //R=results[0].address_components[0].long_name + results[0].address_components[1].long_name;
          $('input#city_lat, input#lat, input#place_lat').val(place.geometry.location.lat());
          $('input#city_lng, input#long, input#place_long').val(place.geometry.location.lng());
          //$('input#place_address_attributes_street_address').val(R[0]);
        } else {
          //alert("Geocode was not successful for the following reason: " + status)
          //better error handling needed
        }
      });
    },
    engagement_share:function(){
      console.log("change the implementation")
    }

  }

  $(function(){
      $('.tabs').tabs({show:function(e,ui){
        if(ui.tab.hash=="#owner_view"){
         google.maps.event.trigger(myMap, 'resize');
         myMap.setZoom(myMap.getZoom());
        }
      }});

      $('#cross_street, #street_address,#location').blur(function(){

        var strAddress  = "";
        var stAddress   = [];
        var address     = [];

        var $stAdd1       = $('#street_address');
        var $crossStreet  = $('#cross_street');

        if($stAdd1.val()!=""){
          strAddress +=" "+$stAdd1.val();

          if( $crossStreet.val()!=""){
            strAddress+=" at "+$crossStreet.val();
          }
        }

        strAddress += " "+$('#location').val();
        MonoV1.find_place_on_map(strAddress);
      });

      $('#city_id, #country_id, #place_address_attributes_street_address, #place_address_attributes_cross_street').blur(function(){

        var strAddress  = "";
        var stAddress   = [];
        var address     = [];

        var $stAdd1       = $('#place_address_attributes_street_address');
        var $crossStreet  = $('#place_address_attributes_cross_street');

        if($stAdd1.val()!=""){
          strAddress +=" "+$stAdd1.val();

          if( $crossStreet.val()!=""){
            strAddress+=" at "+$crossStreet.val();
          }
        }

        strAddress +=" "+$("#city_id").val() +" " + $("#country_id").val();
        MonoV1.find_place_on_map(strAddress);
      });

      $('form.cities #city_name, form.cities #country_id').blur(function(){

        var strAddress  = "";
        var stAddress   = [];
        var address     = [];

        strAddress +=" "+$("form.cities #city_name").val() +" " + $("form.cities #country_id").val();
        MonoV1.find_place_on_map(strAddress);
      });


      $('#country_id').autocomplete({
          source: "/businesses/update_countries.js",
          dataType:"jsonp",
          select:function(e,ui){
            $('input#country').val(ui.item.id);
          }
      });
      $('#city_id').focus(function(){
          var country = $("input#country").val();
          $(this).autocomplete({
          source: "/businesses/update_cities/"+ country +".js",
          dataType:"jsonp",
          select:function(e,ui){
            $('input#city').val(ui.item.id);
          }
          })
      });
   sHours = ["12:00 AM","12:30 AM","11:00 AM","11:30 AM","10:00 AM","10:30 AM","9:00 AM","9:30 AM","8:00 AM","8:30 AM","7:00 AM","7:30 AM","6:00 AM","6:30 AM","5:00 AM","5:30 AM","4:00 AM","4:30 AM","3:00 AM","3:30 AM","2:00 AM","2:30 AM","1:00 AM","1:30 AM","12:00 PM","12:30 PM","11:00 PM","11:30 PM","10:00 PM","10:30 PM","9:00 PM","9:30 PM","8:00 PM","8:30 PM","7:00 PM","7:30 PM","6:00 PM","6:30 PM","5:00 PM","5:30 PM","4:00 PM","4:30 PM","3:00 PM","3:30 PM","2:00 PM","2:30 PM","1:00 PM","1:30 PM"];

   $('input.complete').autocomplete({source:sHours});

    $(".business.complete").autocomplete({source:"/auto_business", select:function(e,ui){
      $(".branch.title").val(ui.item.value);
    }});

    $(".box_eject a").click(function(e){
      var $a = $(this);
      $a.toggleClass("active");
      var $box =  $a.closest(".slide_box_eject").prev('.slide_box_slider').find('.box_slider p');
      $box.slideToggle();
      e.preventDefault();
      e.stopPropagation();
    });


    geocoder = new google.maps.Geocoder();
    marker = new google.maps.Marker();
    marker2 = new google.maps.Marker();
    initialize();

    $('input.complete:eq(0)').autocomplete({
      source:sHours,
      select:function(e,ui){
     from_hour = $('#open_hour_0_from').val(); // the selected value of the first day ( from hour)
      from2_hour = $('#open_hour_0_from2').val(); // the selected value of the first day - if user splits the time( from2 hour)
      from_hour = ui.item.value;
      $('.from_class').each(function(index, element){
        $(this).val(from_hour);
        if(from2_hour){
         $('#open_hour_'+index+'_from2').val(from2_hour)
        }// if from2_hour end
      }); // end of .each function


      }
    });

    $("input.complete:eq(1)").autocomplete({source:sHours,select:function(e,ui){
      to_hour = ui.item.value;
      $('.to_class').each(function(index, element){
        to2_hour = $('#open_hour_0_to2').val(); // the selected value of the first day - if user splits the time ( to2 hour)

        $(this).val(to_hour);
        if(to2_hour){
          $('#open_hour_'+index+'_to2').val(to2_hour);
        }// if from2_hour end
      });


    }});

    $(".title.business.bcomplete").autocomplete({
      source:"/auto_business",
      select:function(e,ui){
        var $b =$(".title.branch");
        if($b.val()==""){
          $b.val(ui.item.value);
        }
    }});

  });
