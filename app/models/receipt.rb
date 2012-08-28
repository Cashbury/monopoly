class Receipt < ActiveRecord::Base
  
  belongs_to :business
  belongs_to :place
  belongs_to :user
  belongs_to :transaction
  belongs_to :transaction_group
  belongs_to :log_group
  belongs_to :campaign, :foreign_key => "spend_campaign_id"

  has_and_belongs_to_many :users, :class_name => "User" , :join_table => "users_pending_receipts"
  
  TYPE = {:spend => "spend", :load => "load"}

  scope :with_joined_details, joins("LEFT OUTER JOIN transaction_groups ON transaction_groups.id = receipts.transaction_group_id")
                             .joins("LEFT OUTER JOIN transactions ON transactions.transaction_group_id = transaction_groups.id")
                             .joins("LEFT OUTER JOIN transaction_types ON transaction_types.id = transactions.transaction_type_id")
                             .joins("LEFT OUTER JOIN roles_users ON receipts.cashier_id = roles_users.user_id and roles_users.role_id = 10")
                             .joins("LEFT OUTER JOIN businesses ON roles_users.business_id = businesses.id")
                             .joins("LEFT OUTER JOIN brands ON brands.id = businesses.brand_id")
                             .joins("LEFT OUTER JOIN log_groups ON log_groups.id = receipts.log_group_id")
                             .joins("LEFT OUTER JOIN logs ON logs.log_group_id = log_groups.id")
                             .joins("LEFT OUTER JOIN campaigns ON campaigns.id = logs.campaign_id")
                             .joins("LEFT OUTER JOIN engagements ON engagements.campaign_id = campaigns.id")
                             .joins("LEFT OUTER JOIN rewards ON rewards.campaign_id = campaigns.id")
                             .joins("LEFT OUTER JOIN places ON logs.place_id = places.id")
                             .select("DISTINCT(receipts.id) as receipt_id, logs.user_id as customer_id, businesses.id as business_id, receipts.current_credit, receipts.earned_points, receipts.ringup_amount as amount_rungup, brands.id as brand_id, engagements.fb_engagement_msg, campaigns.id as campaign_id, logs.user_id, receipts.log_group_id, receipts.transaction_id, receipts.created_at as date_time, places.name as place_name, brands.name as brand_name, receipts.credit_used, receipts.unlocked_credit, receipts.cashbury_act_balance, receipts.remaining_credit, transaction_groups.id as transaction_group_id, rewards.money_amount as cash_reward, places.id as place_id, receipts.tip as tip, transaction_types.name as transaction_type, transactions.state, rewards.id as reward_id") 
                             .where("campaigns.ctype = 1")
                             .group("receipt_id")
  cattr_accessor :current_user                            

  def refund!
    if transaction_group.present?
      transaction_group.refund!(current_user)
    elsif transaction.present?
      transaction.refund!(current_user)
    end  
  end                            
end
