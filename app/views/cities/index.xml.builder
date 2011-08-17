xml.instruct!
xml.cities do
  @cities.each do |city|
    xml.city do
      xml.name city.name
      xml.country do
        xml.coutry_flag "/images/countries/#{city.country.iso2.to_s.downcase}.png"
      end
    end
  end
end
