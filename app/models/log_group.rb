# == Schema Information
# Schema version: 20110615133925
#
# Table name: log_groups
#
#  id         :integer(4)      not null, primary key
#  created_on :date
#  created_at :datetime
#  updated_at :datetime
#

class LogGroup < ActiveRecord::Base
	has_many :logs
	has_many :receipts
	
	
	def get_receipt_engagements
	  self.logs
	      .joins(:engagement=>[:item,:campaign=>[:accounts=>:account_holder]])
	      .select("accounts.amount as current_balance, campaigns.id as campaign_id,logs.gained_amount as amount, engagements.name as title, logs.frequency as quantity")
	      .where("account_holders.model_id=logs.user_id and account_holders.model_type='User'")
  end
end
