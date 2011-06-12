Factory.define :address do |addr|
  addr.street_address "street address"
  addr.neighborhood "neighborhood"
  addr.country_id {Factory(:country).id}
  addr.city_id {Factory(:city).id}
  addr.zipcode "21111"
end