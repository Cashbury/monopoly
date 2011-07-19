class EngagementType < ActiveRecord::Base
  has_many :engagements
  belongs_to :business
  
  TYPES={
    :buy=>"Buy",
    :spend=>"Spend",
    :visit=>"Visit/Check-IN"
  }
  
  ENG_TYPE={
    :buy=>1,
    :visit=>2,
    :spend=>3
  }
  
  def display_name
    TYPES[self.name.to_sym]
  end
end
