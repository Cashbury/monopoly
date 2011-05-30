class City < ActiveRecord::Base
  belongs_to :country
  has_many :addresses
  acts_as_mappable
  
  
  def closest(options = {})
    geo_scope(options).order("#{distance_column_name} asc").limit(1)
  end

end
