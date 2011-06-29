module PlacesHelper
  def set_variables(place)
    if(place)
      @address = place.address
      @street_address = @address.street_address
      @location = "#{@address.city.try(:name)}, #{@address.country.try(:name) }"
      @cross_street = @address.cross_street
      @phone = place.phone
      @neighborhood = @address.neighborhood
    end
  end
end
