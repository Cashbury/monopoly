# == Schema Information
# Schema version: 20101218032208
#
# Table name: places
#
#  id          :integer         primary key
#  name        :string(255)
#  long        :string(255)
#  lat         :string(255)
#  business_id :integer
#  description :text
#  created_at  :timestamp
#  updated_at  :timestamp
#

class Place < ActiveRecord::Base
	acts_as_mappable  :lng_column_name => :long
	acts_as_taggable
  belongs_to :business
  belongs_to :place_type
  belongs_to :address
  
  has_and_belongs_to_many :amenities
  
  has_many :qr_codes,:as=>:associatable
  has_many :open_hours
  has_many :followers, :as=>:followed
  
  attr_accessible :name, :long, :lat, :description, :business, :time_zone
  accepts_nested_attributes_for :address

  validates_presence_of :name, :long, :lat 
  validates_numericality_of :long,:lat 
  
  
  def is_open?
    current_datetime=DateTime.now.in_time_zone(self.time_zone)
    !self.open_hours.where(["open_hours.from <= ? and open_hours.to >=?", current_datetime, current_datetime]).empty?
  end
end
