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
  }

  var MonoV1 = {
    find_place_on_map:function(e){
      var strAddress = "";
      var stAddress = [];
      var address = [];

      var $stAdd1 = jQuery('#place_address_attributes_street_address');
      var $stAdd2 = jQuery('#street-address2');
      var $crossStreet = jQuery('#cross-street');

      if($stAdd1.val()!="") stAddress.push($stAdd1.val());
      if($stAdd2.val()!="") stAddress.push($stAdd2.val());
      if(stAddress.length>0) {
        strAddress += stAddress.join(" ,");
        if($crossStreet.val()!=""){
          strAddress+=" at "+$crossStreet.val();
        }
      }

      var $city = jQuery('#city_id');
      var $neighborhood = jQuery('#place_address_attributes_neighborhood');

      if($neighborhood.val()!="") address.push($neighborhood.val())
      if($city.val()!="") address.push($city.val());
      strAddress += address.join(" ,");

      geocoder.geocode( { 'address': strAddress }, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
          map.setZoom(16);
          map.setCenter(results[0].geometry.location);
          marker.setPosition(results[0].geometry.location);
          jQuery('#place_lat').val(results[0].geometry.location.Ha);
          jQuery('#place_long').val(results[0].geometry.location.Ia);
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

      jQuery('#cross-street, #place_address_attributes_street_address,#city_id, #place_address_attributes_neighborhood').blur(MonoV1.find_place_on_map);

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

      initialize();
  });
