# == Schema Information
# Schema version: 20110615133925
#
# Table name: transactions
#
#  id                          :integer(4)      not null, primary key
#  from_account                :integer(4)
#  to_account                  :integer(4)
#  before_fees_amount          :decimal(20, 3)
#  payment_gateway             :string(255)
#  is_money                    :boolean(1)
#  created_at                  :datetime
#  updated_at                  :datetime
#  from_account_balance_before :decimal(20, 3)
#  from_account_balance_after  :decimal(20, 3)
#  to_account_balance_before   :decimal(20, 3)
#  to_account_balance_after    :decimal(20, 3)
#  currency                    :string(255)
#  note                        :text
#  transaction_type_id         :integer(4)
#  after_fees_amount           :decimal(20, 3)
#  transaction_fees            :decimal(20, 3)
#

class Transaction < ActiveRecord::Base
  belongs_to :account
  belongs_to :transaction_type
  
  has_many :logs
	validates_presence_of :from_account, :to_account,:transaction_type_id, 
	                      :from_account_balance_before,:from_account_balance_after, 
	                      :to_account_balance_before,:to_account_balance_after
end
