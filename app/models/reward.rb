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
  
  has_many :logs
  has_and_belongs_to_many :items
  has_and_belongs_to_many :users
  has_and_belongs_to_many :enjoyed_users, :class_name=>"User" , :join_table => "users_enjoyed_rewards"
  
  has_one :reward_image, :as => :uploadable, :dependent => :destroy
  accepts_nested_attributes_for :reward_image
  #attr_accessor :places_list
  
  #after_save :update_categories
  validates_presence_of :campaign_id,:name,:needed_amount,:heading1,:heading2,:legal_term
  validates_numericality_of :needed_amount,:max_claim
  
  #  private
  # def update_categories
  #   places.delete_all
  #   selected_categories = places_list.nil? ? [] : places_list.keys.collect{|id| Place.find(id)}
  #   selected_categories.each {|place| self.places << place}
  # end
  
  def self.get_available_items(campaign_id) # this should be refactored to scopes
    @places = Campaign.where(:id =>campaign_id).first.places
    @items = @places[0].items if @places[0]
    @places.each do |place|
      @items = @items | place.items
    end
    return @items
  end
  
  def is_claimed_by(user,user_account,place_id,lat,lng)
    business_account=self.campaign.business_account
    date=Date.today.to_s
		Account.transaction do
		  user.enjoyed_rewards << self
		  user.save
		  #debit user account and credit business account
      action=Action.where(:name=>Action::CURRENT_ACTIONS[:redeem]).first
      transaction_type=action.transaction_type
      after_fees_amount=transaction_type.fee_amount.nil? ? self.needed_amount : self.needed_amount-transaction_type.fee_amount
      after_fees_amount=transaction_type.fee_percentage.nil? ? after_fees_amount : (after_fees_amount-(after_fees_amount * transaction_type.fee_percentage/100))
      
      user_account_before_balance=user_account.amount
      user_account.decrement!(:amount,self.needed_amount)
      
      business_account_before_balance=business_account.amount
      business_account.increment(:amount,after_fees_amount)
      
      #save the transaction record
      transaction=Transaction.create!(:from_account=>user_account.id,
                                      :to_account=>business_account.id,
                                      :before_fees_amount=>self.needed_amount,
                                      :payment_gateway=>user_account.payment_gateway,
                                      :is_money=>false,
                                      :from_account_balance_before=>user_account_before_balance,
                                      :from_account_balance_after=>user_account.amount,
                                      :to_account_balance_before=>business_account_before_balance,
                                      :to_account_balance_after=>business_account.amount,
                                      :currency=>nil,
                                      :note=>"User claimed a reward",
                                      :transaction_type_id=>action.transaction_type_id,
                                      :after_fees_amount=>after_fees_amount,
                                      :transaction_fees=>transaction_type.fee_amount)
                                      
			log_group=LogGroup.create!(:created_on=>date)
			Log.create!(:user_id        =>user.id,
                  :action_id      =>action.id,
                  :log_group_id   =>log_group.id,
                  :reward_id     =>self.id,
                  :business_id    =>self.campaign.program.business.id,
                  :transaction_id =>transaction.id,
                  :place_id       =>place_id,
                  :gained_amount  =>after_fees_amount,
                  :amount_type    =>user_account.measurement_type,
                  :frequency      =>1,
                  :lat            =>lat,
                  :lng            =>lng,
                  :created_on     =>date)
		end
  end
end
