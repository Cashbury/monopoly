# == Schema Information
# Schema version: 20101219014735
#
# Table name: rewards
#
#  id            :integer         primary key
#  name          :string(255)
#  engagement_id :integer
#  created_at    :timestamp
#  updated_at    :timestamp
#  campaign_id   :integer
#  place_id      :integer
#  description   :text
#  points        :integer
#

class Reward < ActiveRecord::Base
  belongs_to :engagement
  belongs_to :business
  belongs_to :program
  
  has_and_belongs_to_many :places
  
  attr_accessor :places_list
  
  after_save :update_categories
  
  #  private
  def update_categories
    places.delete_all
    selected_categories = places_list.nil? ? [] : places_list.keys.collect{|id| Place.find(id)}
    selected_categories.each {|place| self.places << place}
  end
end
