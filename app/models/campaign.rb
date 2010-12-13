class Campaign < ActiveRecord::Base
  has_and_belongs_to_many :places
  has_many :engagements
  attr_accessible :name, :action, :expire_at, :campaign_type, :places_list
  attr_accessor :places_list
  
  after_save :update_places
  
  def campaign_types
    ["grow", "engage", "re-engage"]
  end
  
  private
  def update_places
    places.delete_all
    selected_places = places_list.nil? ? [] : places_list.keys.collect{|id| Place.find(id)}
    selected_places.each {|place| self.places << place}
  end
end