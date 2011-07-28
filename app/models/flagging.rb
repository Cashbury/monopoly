class Flagging < ActiveRecord::Base

  def self.popular
    cities = group("flaggable_id").count
    cc = []
    cities.each do |city_id, city_count|
      cc << city_id
    end
    ci = City.find(cc)
    data = ci.map do |city|
      { :name => city.name ,:count=>cities[city.id]}
    end
  end
end
