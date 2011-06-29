
function initialize() {
    var latlng = new google.maps.LatLng(-34.397, 150.644);
    var myOptions = {
      zoom: 8,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    myMap = new google.maps.Map(jQuery("#map_canvas")[0], myOptions);
    myMap2 = new google.maps.Map(jQuery("#my_map2")[0], myOptions);

    google.maps.event.addListener(marker,"dragend",function(){
        myMap.panTo(marker.getPosition());
        myMap2.panTo(marker.getPosition());
        jQuery('input#lat,input#place_lat').val(marker.getPosition().lat());
        jQuery('input#long,input#place_long').val(marker.getPosition().lng());
    });
    google.maps.event.addListener(marker2,"dragend",function(){
        myMap.panTo(marker2.getPosition());
        myMap2.panTo(marker2.getPosition());
        jQuery('input#lat,input#place_lat').val(marker2.getPosition().lat());
        jQuery('input#long,input#place_long').val(marker2.getPosition().lng());
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

          myMap2.setZoom(17);
          marker2.setDraggable(true);
          marker2.setPosition(place.geometry.location);
          myMap2.setCenter(place.geometry.location);
          marker2.setMap(myMap2);

          R = [""];
          R = results[0].formatted_address.split(',');
          //R=results[0].address_components[0].long_name + results[0].address_components[1].long_name;
          jQuery('input#lat, input#place_lat').val(results[0].geometry.location.lat());
          jQuery('input#long,input#place_long').val(results[0].geometry.location.lng());
          jQuery('input#place_address_attributes_street_address').val(R[0]);
        } else {
          //alert("Geocode was not successful for the following reason: " + status)
          //better error handling needed
        }
      });
    }
  }

  jQuery(function(){
      jQuery.EnablePlaceholder.defaults.withPlaceholderClass = 'title';
      jQuery('input[type=text]').enablePlaceholder();
      jQuery('.tabs').tabs({show:function(e,ui){
        if(ui.tab.hash=="#owner_view"){
         google.maps.event.trigger(myMap, 'resize');
         myMap.setZoom(myMap.getZoom());
        }
      }});

      jQuery('#cross_street, #street_address,#location').blur(function(){

        var strAddress  = "";
        var stAddress   = [];
        var address     = [];

        var $stAdd1       = jQuery('#street_address');
        var $crossStreet  = jQuery('#cross_street');

        if($stAdd1.val()!=""){
          strAddress +=" "+$stAdd1.val();

          if( $crossStreet.val()!=""){
            strAddress+=" at "+$crossStreet.val();
          }
        }

        strAddress += " "+jQuery('#location').val();
        MonoV1.find_place_on_map(strAddress);
      });

      jQuery('#place_address_attributes_street_address, #place_address_attributes_cross_street').blur(function(){

        var strAddress  = "";
        var stAddress   = [];
        var address     = [];

        var $stAdd1       = jQuery('#place_address_attributes_street_address');
        var $crossStreet  = jQuery('#lace_address_attributes_cross_street`');

        if($stAdd1.val()!=""){
          strAddress +=" "+$stAdd1.val();

          if( $crossStreet.val()!=""){
            strAddress+=" at "+$crossStreet.val();
          }
        }

        MonoV1.find_place_on_map(strAddress);
      });


      jQuery('#country_id').autocomplete({
          source: "/businesses/update_countries.js",
          dataType:"jsonp",
          select:function(e,ui){
            jQuery('input#place_address_attributes_country_id').val(ui.item.id);
          }
      });
      jQuery('#city_id').autocomplete({
          source: "/businesses/update_cities/"+jQuery('#country_id').val() +".js",
          dataType:"jsonp",
          select:function(e,ui){
            jQuery('input#place_address_attributes_city_id').val(ui.item.id);
          }
      });
   sHours = ["12:00 AM","12:30 AM","11:00 AM","11:30 AM","10:00 AM","10:30 AM","9:00 AM","9:30 AM","8:00 AM","8:30 AM","7:00 AM","7:30 AM","6:00 AM","6:30 AM","5:00 AM","5:30 AM","4:00 AM","4:30 AM","3:00 AM","3:30 AM","2:00 AM","2:30 AM","1:00 AM","1:30 AM","12:00 PM","12:30 PM","11:00 PM","11:30 PM","10:00 PM","10:30 PM","9:00 PM","9:30 PM","8:00 PM","8:30 PM","7:00 PM","7:30 PM","6:00 PM","6:30 PM","5:00 PM","5:30 PM","4:00 PM","4:30 PM","3:00 PM","3:30 PM","2:00 PM","2:30 PM","1:00 PM","1:30 PM"];
    jQuery('input.complete').autocomplete({source:sHours});


    jQuery(".box_eject a").click(function(e){
      var $a = jQuery(this);
      $a.toggleClass("active");
      var $box =  $a.closest(".slide_box_eject").prev('.slide_box_slider').find('.box_slider p');
      $box.slideToggle();
      e.preventDefault();
      e.stopPropagation();
    });

    jQuery('.box_slider:first').show();

    geocoder = new google.maps.Geocoder();
    marker = new google.maps.Marker();
    marker2 = new google.maps.Marker();
    initialize();
  });
