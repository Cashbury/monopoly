  var map;
  var geocoder;
  var marker;
   function initialize() {
    var latlng = new google.maps.LatLng(-34.397, 150.644);
    var myOptions = {
      zoom: 8,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
    geocoder = new google.maps.Geocoder();
    marker = new google.maps.Marker({map:map});
    google.maps.event.addListener(marker,"dragend",function(){
        map.panTo(marker.getPosition());
        jQuery('input#lat').val(marker.getPosition().lat());
        jQuery('input#long').val(marker.getPosition().lng());
    });
  }

  var MonoV1 = {
    find_place_on_map:function(e){
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

      geocoder.geocode( { 'address': strAddress }, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
          place = results[0];
          map.setZoom(17);
          map.setCenter(results[0].geometry.location);
          marker.setPosition(results[0].geometry.location);
          marker.setDraggable(true);
          R = ["",""];
          R = results[0].formatted_address.split(',');
          //R=results[0].address_components[0].long_name + results[0].address_components[1].long_name;
          jQuery('input#lat, input#place_lat').val(results[0].geometry.location.lat());
          jQuery('input#long,input#place_long').val(results[0].geometry.location.lng());
          jQuery('input#place_address_attributes_street_address').val(R[0]+R[1]);
        } else {
          //alert("Geocode was not successful for the following reason: " + status)
          //better error handling needed
        }
      });
    },
    add_registration_validation:{
    }

  }

  jQuery(function(){
      jQuery.EnablePlaceholder.defaults.withPlaceholderClass = 'title';
      jQuery('input.title[type=text]').enablePlaceholder();
      jQuery('.tabs').tabs();

      jQuery('#cross_street, #street_address,#location').blur(MonoV1.find_place_on_map);

      jQuery('form#step1').validate(MonoV1.add_registration_validation);


      jQuery('#country_id').autocomplete({
          source: "/businesses/update_countries.js",
          dataType:"jsonp",
          select:function(e,ui){
            jQuery('input#place_address_attributes_country_id').val(ui.item.id);
          }
      });
      jQuery('#city_id').autocomplete({
          source: "/businesses/update_cities/1.js",
          dataType:"jsonp",
          select:function(e,ui){
            jQuery('input#place_address_attributes_city_id').val(ui.item.id);
          }
      });

      //initialize();
  });
