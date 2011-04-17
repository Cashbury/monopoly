# == Schema Information
# Schema version: 20101218032208
#
# Table name: engagements
#
#  id              :integer         primary key
#  engagement_type :string(255)
#  state           :string(255)
#  description     :string(255)
#  campaign_id     :integer
#  created_at      :timestamp
#  updated_at      :timestamp
#  name            :string(255)
#
require 'uri'
require "digest"

class Engagement < ActiveRecord::Base
  
  belongs_to :program
  belongs_to :reward
  belongs_to :engagement_type
  has_and_belongs_to_many :places

  has_many :qr_codes
  
  
  scope :stamps, where(:engagement_type => QrCode::STAMP) 
  
  attr_accessor :places_list
  after_save :update_places
 
  validates :name, :presence =>true,
                   :length =>{:within=>3..50}
  validates_presence_of :description,:amount                   
  validates_numericality_of :amount
  validates_presence_of :engagement_type_id
  
  STATES={
    true => "started",
    false => "stopped"
    }
  #  private
  def update_places    
    places.delete_all
    selected_places = places_list.nil? ? [] : places_list.keys.collect{|id| Place.find(id)}
    selected_places.each{|place|
      self.places << place
    }    
  end  
  
  def start
    self.state=true
    save!
  end
  def stop
    self.state=false
    save!
  end
end
