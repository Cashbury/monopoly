# == Schema Information
# Schema version: 20110615133925
#
# Table name: accounts
#
#  id                  :integer(4)      not null, primary key
#  created_at          :datetime
#  updated_at          :datetime
#  account_holder_id   :integer(4)
#  campaign_id         :integer(4)
#  measurement_type_id :integer(4)
#  amount              :decimal(20, 3)
#  is_money            :boolean(1)
#  is_external         :boolean(1)
#  payment_gateway_id  :integer(4)
#  program_id          :integer(4)
#  business_id         :integer(4)
#

class Account < ActiveRecord::Base
  belongs_to :account_holder
  belongs_to :campaign
  belongs_to :measurement_type
  belongs_to :payment_gateway
  
  has_many :transactions, :foreign_key=>"from_account"
  
  validates_uniqueness_of :account_holder_id, :scope => :campaign_id
  validates_presence_of :measurement_type_id
  validates_numericality_of :amount
end
