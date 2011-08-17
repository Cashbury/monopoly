module PlacesHelper
  def set_variables(place)
    @country_name = ""
    @city_name = ""
    if(place)
      @address = place.address
      @street_address = @address.street_address
      @location = "#{@address.city.try(:name)}, #{@address.city.try(:country).try(:name) }"
      @city_name= @address.city.try(:name)
      @country_name= @address.city.try(:country).try(:name)
      @cross_street = @address.cross_street
      @phone = place.phone
      @neighborhood = @address.neighborhood
      @pname =place.name
      @cname = place.try(:business).try(:name)
    end
  end

  def get_maker_position_script(place)
    unless place.id.nil?
    "pos = new google.maps.LatLng("+ @place.lat.to_s + "," + @place.long.to_s + ");  myMap2.setZoom(17);myMap.setZoom(17);marker.setPosition(pos);marker2.setPosition(pos);marker2.setMap(myMap);myMap.setCenter(pos);myMap2.setCenter(pos);marker.setMap(myMap2);"
    end
  end
end
