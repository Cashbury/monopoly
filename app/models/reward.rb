# == Schema Information
# Schema version: 20101219014735
#
# Table name: rewards
#
#  id            :integer         primary key
#  name          :string(255)
#  engagement_id :integer
#  created_at    :timestamp
#  updated_at    :timestamp
#  campaign_id   :integer
#  place_id      :integer
#  description   :text
#  points        :integer
#

class Reward < ActiveRecord::Base
  belongs_to :campaign
  has_and_belongs_to_many :items
  has_and_belongs_to_many :users
  
  #attr_accessor :places_list
  
  #after_save :update_categories
  validates_presence_of :campaign_id,:name,:needed_amount,:description,:legal_term
  validates_numericality_of :needed_amount,:claim
  
  #  private
  # def update_categories
  #   places.delete_all
  #   selected_categories = places_list.nil? ? [] : places_list.keys.collect{|id| Place.find(id)}
  #   selected_categories.each {|place| self.places << place}
  # end
  
  def is_claimed_by(user,account,place_id,lat,lng)
    date=Date.today.to_s
		Account.transaction do
			account.decrement!(:amount,self.needed_amount)
			log_group=LogGroup.create!(:created_on=>date)
      Log.create!(:user_id       =>user.id,
                  :log_type      =>Log::LOG_TYPES[:redeem],
                  :log_group_id  =>log_group.id,
                  :reward_id     =>self.id,
                  :business_id   =>self.campaign.program.business.id,
                  :place_id      =>place_id,
                  :amount        =>self.needed_amount,
                  :amount_type   =>account.measurement_type,
                  :frequency     =>1,
                  :lat           =>lat,
                  :lng           =>lng,
                  :created_on    =>date)
		end
  end
end
