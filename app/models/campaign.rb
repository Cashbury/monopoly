class Campaign < ActiveRecord::Base
  has_and_belongs_to_many :places
  has_many :engagements
  attr_accessible :name, :action, :expire_at
  
  def campaign_types
    ["grow", "engage", "re-engage"]
  end
end