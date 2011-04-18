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
  belongs_to :campaign
  belongs_to :engagement_type
  
  
  scope :stamps, where(:engagement_type => QrCode::STAMP) 
  
  attr_accessor :places_list
 
  validates :name, :presence =>true,
                   :length =>{:within=>3..50}

  validates_presence_of :engagement_type_id,:description,:amount                   
  validates_numericality_of :amount
  
  def engagement_types
    ["check-in", QrCode::STAMP , "question", "spend"]
  end
  
  def get_states
    ["deployed", "paused", "offline"]
  end
  
  STATES={
    true => "started",
    false => "stopped"
    }
  
  def start
    self.state=true
    save!
  end
  
  def stop
    self.state=false
    save!
  end
end
