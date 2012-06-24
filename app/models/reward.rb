# == Schema Information
# Schema version: 20110615133925
#
# Table name: rewards
#
#  id                 :integer(4)      not null, primary key
#  name               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  needed_amount      :integer(10)
#  max_claim          :integer(4)      default(0)
#  expiry_date        :datetime
#  legal_term         :text
#  campaign_id        :integer(4)
#  max_claim_per_user :integer(4)      default(0)
#  is_active          :boolean(1)
#  product_id         :integer(4)
#  heading1           :text
#  heading2           :text
#  sales_price        :decimal(20, 3)
#  offer_price        :decimal(20, 3)  default(0.0)
#  cost               :decimal(20, 3)
#  foreign_identifier :string(255)
#  start_date         :datetime
#

class Reward < ActiveRecord::Base
  belongs_to :campaign

  has_many :logs
  has_and_belongs_to_many :items
  has_and_belongs_to_many :users
  has_and_belongs_to_many :enjoyed_users, :class_name=>"User" , :join_table => "users_enjoyed_rewards"

  has_one :reward_image, :as => :uploadable, :dependent => :destroy
  accepts_nested_attributes_for :reward_image
  #attr_accessor :places_list

  attr_accessor :end_date
  #after_save :update_categories
  validates_presence_of :name, :needed_amount #, :fb_unlock_msg, :fb_enjoy_msg
  validates_numericality_of :needed_amount, :greater_than => 0
  validates_numericality_of :max_claim , :allow_nil=>true
  validates_length_of :name, :maximum => 25#16
  validates_length_of :heading1, :maximum => 40
  validates_length_of :heading2, :maximum => 150 #84
  validate :spend_campaign_dates
  
  after_update :reprocess_photo

  cattr_reader :per_page
  @@per_page = 20
  
  def spend_campaign_dates
    if self.end_date.present? and self.expiry_date.present? and self.end_date.to_date > self.expiry_date.to_date
      errors.add_to_base "Spend until date should be less that or equal the offer availability date"
    end
  end
  
  def reprocess_photo
    if !self.reward_image.nil? and self.reward_image.cropping?
      self.reward_image.photo.reprocess!
      self.reward_image.save!
    end
  end
  #  private
  # def update_categories
  #   places.delete_all
  #   selected_categories = places_list.nil? ? [] : places_list.keys.collect{|id| Place.find(id)}
  #   selected_categories.each {|place| self.places << place}
  # end
  def self.get_available_items(campaign_id) # this should be refactored to scopes
    Campaign.find(campaign_id).places.joins(:items).select("DISTINCT items.*")
    # @places = Campaign.where(:id =>campaign_id).first.places
    # @items = @places[0].items if @places[0]
    # @places.each do |place|
    #   @items = @items | place.items
    # end
    # return @items
  end

  def is_claimed_by(user, user_account, place_id, lat, lng)
    business_account = self.campaign.business_account
    options = {
      :action => :redeem,
      :amount => self.needed_amount,
      :from_account => user_account,
      :to_account => business_account,
      :campaign => self.campaign,
      :user => user,
      :place_id => place_id,
      :lat => lat,
      :lng => lng,
      :not => "User claimed a reward",
      :reward => self
    }    
    Transaction.fire(options)
    user.enjoyed_rewards << self
    user.save
  end
  
  def is_unlocked?(user)
    self.campaign.user_account(user).amount >= self.needed_amount
  end
  
  def money_amount
    self[:money_amount].round(2) if self[:money_amount].present?
  end
  
  def is_available_to?(user)
    eng = self.campaign.engagements.first
    (eng.present? and eng.end_date.nil? and self.expiry_date.nil?) || (eng.present? and eng.end_date.present? and Date.today <= eng.end_date.to_date) || (self.expiry_date.present? and Date.today <= self.expiry_date.to_date and is_unlocked?(user))
  end
end
