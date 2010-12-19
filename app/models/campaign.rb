# == Schema Information
# Schema version: 20101218032208
#
# Table name: campaigns
#
#  id            :integer         not null, primary key
#  name          :string(255)
#  campaign_type :string(255)
#  expire_at     :datetime
#  created_at    :datetime
#  updated_at    :datetime
#  business_id   :integer
#

class Campaign < ActiveRecord::Base
  #has_and_belongs_to_many :places
  has_many :engagements
  has_many :rewards
  belongs_to :business
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
