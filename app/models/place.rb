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
  belongs_to :business
  
  has_and_belongs_to_many :engagements
  has_and_belongs_to_many :rewards
  
  has_many :reports, :as => :reportable

  attr_accessible :name, :long, :lat, :description,:address1, :address2 , :neighborhood, :city , :zipcode  
end