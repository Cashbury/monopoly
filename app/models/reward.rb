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
  belongs_to :business
  belongs_to :program
	has_many   :engagements
  has_many   :user_actions
  has_and_belongs_to_many :places
  
  attr_accessor :places_list
  
  after_save :update_categories
  validates_presence_of :program_id,:name,:points,:description,:price
  validates_numericality_of :price,:points
  validate do |reward|
    reward.errors.add_to_base("#{reward.program.name} already has an auto unlock reward") if reward.auto_unlock && reward.program.has_auto_unlock_reward?
  end
  scope :auto_unlocked_ones, where(:auto_unlock=>true)
  scope :normal_ones, where(:auto_unlock=>false)
  #  private
  def update_categories
    places.delete_all
    selected_categories = places_list.nil? ? [] : places_list.keys.collect{|id| Place.find(id)}
    selected_categories.each {|place| self.places << place}
  end
  
  def is_claimed_by(user)
  	account=nil
		Account.transaction do
			account=user.accounts.where(:program_id=>self.program.id).first 
			account.increment!(:points,self.points) if self.auto_unlock
			account.decrement!(:points,self.points)
			UserAction.create!(:user_id=>user.id,:reward_id=>self.id,:used_at=>Date.today)
		end
		account
  end
end
