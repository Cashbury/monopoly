# == Schema Information
# Schema version: 20110615133925
#
# Table name: cities
#
#  id         :integer(4)      not null, primary key
#  country_id :integer(4)
#  name       :string(255)
#  lat        :decimal(15, 10)
#  lng        :decimal(15, 10)
#

class City < ActiveRecord::Base
  attr_accessible :name, :country_id, :lat, :lng, :area_code, :is_live

  belongs_to :country
  has_many :addresses

  acts_as_mappable
  make_flaggable :like , :popular

  def closest(options = {})
    geo_scope(options).order("#{distance_column_name} asc").limit(1)
  end

end
