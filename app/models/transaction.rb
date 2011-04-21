class Transaction < ActiveRecord::Base
  belongs_to :transaction_type
  has_many :logs
	validates_presence_of :from_account, :to_account,:transaction_type_id, 
	                      :from_account_balance_before,:from_account_balance_after, 
	                      :to_account_balance_before,:to_account_balance_after
end
