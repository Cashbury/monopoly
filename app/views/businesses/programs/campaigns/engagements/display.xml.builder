xml.instruct!
xml.response do |response|
  response.engagement(:id => @engagement.id) do |engagement|
    engagement.name @engagement.name
    engagement.description @engagement.description
    engagement.points @engagement.points

    engagement.business(:id => @engagement.business.id) do |business|
      business.name @engagement.business.name
    end
    
    engagement.places do |p|
      @engagement.places.each do |place|
        p.name place.name
        p.coordinates "#{place.long}, #{place.lat}"
      end
    end
  end
end