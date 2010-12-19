xml.instruct!
xml.response do |response|
  response.engagement(:id => @engagement.id) do |engagement|
    engagement.name @engagement.name
    engagement.description @engagement.description
    engagement.points @engagement.points

    engagement.business(:id => @engagement.campaign.business.id) do |business|
      business.name @engagement.campaign.business.name
    end
    
    engagement.campaign(:id => @engagement.campaign.id) do |campaign|
      campaign.name @engagement.campaign.name
      campaign.expire_at @engagement.campaign.expire_at
      campaign.places do |p|
        @engagement.campaign.places.each do |place|
          p.name place.name
          p.coordinates "#{place.long}, #{place.lat}"
        end
      end
    end
  end
end