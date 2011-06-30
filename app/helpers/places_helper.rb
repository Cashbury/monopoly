module PlacesHelper
  def set_variables(place)
    @country_name = ""
    @city_name = ""
    if(place)
      @address = place.address
      @street_address = @address.street_address
      @location = "#{@address.city.try(:name)}, #{@address.country.try(:name) }"
      @city_name= @address.city.try(:name)
      @country_name= @address.country.try(:name)
      @cross_street = @address.cross_street
      @phone = place.phone
      @neighborhood = @address.neighborhood
      @pname =place.name
      @cname = place.try(:business).try(:name)
    end
  end
end
