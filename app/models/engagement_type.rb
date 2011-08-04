class EngagementType < ActiveRecord::Base
  has_many :engagements
  belongs_to :business

  TYPES={
    :buy=>"Buy",
    :spend=>"Spend",
    :visit=>"Visit/Check-IN",
    :share => " Share"
  }

  ENG_TYPE={
    :buy=>1,
    :visit=>2,
    :spend=>3,
    :share=>4,
  }

  def display_name
    TYPES[self.name.to_sym]
  end

  def self.list
    where("name !='share'").order("name ASC")
  end


  def self.share_id
    where("name='share'").try(:first).try(:eng_type)
  end
end
