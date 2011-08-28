xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8" 
xml.cities do
  @cities.each do |city|
    xml.city do
      xml.name city.name
      xml.id   city.id
      city_obj= City.find(city.id)
      xml.flag_url URI.escape("http://#{request.host_with_port}#{city_obj.country.flag_url}") if city_obj.country.flag_url.present?
    end
  end
end
