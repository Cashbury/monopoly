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
