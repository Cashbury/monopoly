# == Schema Information
# Schema version: 20110615133925
#
# Table name: transaction_types
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  fee_amount     :decimal(20, 3)
#  fee_percentage :decimal(20, 3)
#  created_at     :datetime
#  updated_at     :datetime
#

class TransactionType < ActiveRecord::Base
  has_many :transactions
  has_many :actions
  validates_presence_of :name
  accepts_nested_attributes_for :actions
  
  attr_accessible :actions_ids,:name,:fee_amount,:fee_percentage
  attr_accessor :actions_ids
  after_save :set_actions
  
  def set_actions
    self.actions.delete_all
    Action.update_all({:transaction_type_id=>self.id},{:id=>actions_ids})
  end
end
