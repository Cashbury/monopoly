# == Schema Information
# Schema version: 20110615133925
#
# Table name: countries
#
#  id   :integer(4)      not null, primary key
#  name :string(255)
#  abbr :string(255)
#

class Country < ActiveRecord::Base
  # attr_accessible
  has_many :cities
  has_many :addresses
  has_one  :address_profile
  has_attached_file :currency_icon , :styles=>{
                                        :small=>"8x8",
                                        :medium=>"16x16",
                                        :large=>"32x32"
                                      }
end
