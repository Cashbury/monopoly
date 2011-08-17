# == Schema Information
# Schema version: 20110615133925
#
# Table name: addresses
#
#  id             :integer(4)      not null, primary key
#  country_id     :integer(4)
#  city_id        :integer(4)
#  zipcode        :string(255)
#  neighborhood   :string(255)
#  street_address :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Address < ActiveRecord::Base
  belongs_to :city
  #belongs_to :country
  has_many :places
  validates_presence_of :city_id#, :country_id
  attr_accessible :zipcode, :city_id, :neighborhood, :street_address, :cross_street#, :country_id
  
  def common_address
    "#{self.try(:street_address)} , #{self.try(:zipcode)} , #{self.try(:city).try(:country).try(:name)}"
  end
end
