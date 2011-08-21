class Engagement < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :engagement_type
  belongs_to :item

  has_many :qr_codes, :as=>:associatable
  has_many :logs

  scope :stamps, where(:engagement_type => QrCode::STAMP)
  attr_accessor :places_list

  validates :name, :presence =>true,
                   :length =>{:within=>3..50}

  validates_presence_of :engagement_type_id, :amount#, :fb_engagement_msg
  #validates_presence_of :item_id, :if=>Proc.new{|eng| eng.engagement_type.eng_type==EngagementType::ENG_TYPE[:buy]}
  validates_numericality_of :amount
  
  def validate
    if self.new_record? and self.engagement_type_id== EngagementType.where(:name=>"spend").first.try(:id) and self.campaign.present? and self.campaign.engagements.any? 
      errors.add_to_base "There is an already created Spend Engagement under this Campaign"
    end
  end
  
  def engagement_types
    ["check-in", QrCode::STAMP , "question", "spend"]
  end


  def get_states
    ["deployed", "paused", "offline"]
  end


  def items_list(campaign)
    campaign.places.joins(:items).select("DISTINCT items.*")
  end


  def start
    self.is_started =true
    save!
  end


  def stop
    self.is_started=false
    save!
  end



end

# == Schema Information
# Schema version: 20110615133925
#
# Table name: engagements
#
#  id                 :integer(4)      not null, primary key
#  is_started         :boolean(1)      default(TRUE)
#  description        :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  name               :string(255)
#  amount             :decimal(20, 3)
#  campaign_id        :integer(4)
#  engagement_type_id :integer(4)
#  item_id            :integer(4)
#

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
