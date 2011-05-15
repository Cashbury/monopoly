# == Schema Information
# Schema version: 20101218032208
#
# Table name: accounts
#
#  id         :integer         not null, primary key
#  points     :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
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