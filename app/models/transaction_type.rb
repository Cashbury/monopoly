class TransactionType < ActiveRecord::Base
  has_many :transactions
  has_many :actions
  validates_presence_of :name
end
