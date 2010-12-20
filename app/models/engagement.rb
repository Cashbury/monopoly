# == Schema Information
# Schema version: 20101218032208
#
# Table name: engagements
#
#  id              :integer         primary key
#  engagement_type :string(255)
#  points          :string(255)
#  state           :string(255)
#  description     :string(255)
#  campaign_id     :integer
#  created_at      :timestamp
#  updated_at      :timestamp
#  name            :string(255)
#
require 'uri'

class Engagement < ActiveRecord::Base
  belongs_to :campaign
  has_and_belongs_to_many :places
  #attr_accessible :engagement_type,:name,  :stamp, :campaign_id, :state, :points, :description ,:place_id
 
  validates :name , :presence =>true,
                    :length =>{:within=>3..50}

  def engagement_types
    ["check-in", "stamp", "question", "spend"]
  end
  
  def get_states
    ["deployed", "paused", "offline"]
  end
  
  attr_accessor :places_list

  
  after_save :update_places
  
  
  #  private
  def update_places    
    places.delete_all
    selected_places = places_list.nil? ? [] : places_list.keys.collect{|id| Place.find(id)}
    selected_places.each{|place|
      self.places << place
    }    
  end  
  
  #TODO this may move to model :) 
  def self.qrcode(place_id,engagement_id,points)
    code =  "http://kazdoor.heroku.com?place_id=#{place_id}&engagement_id=#{engagement_id}&points=#{points}"    
    "http://qrcode.kaywa.com/img.php?s=6&t=p&d="+URI.escape(code,Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end
  

end
