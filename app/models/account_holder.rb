# == Schema Information
# Schema version: 20110615133925
#
# Table name: account_holders
#
#  id         :integer(4)      not null, primary key
#  model_type :string(255)
#  model_id   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class AccountHolder < ActiveRecord::Base
  belongs_to :user, :polymorphic => true
  belongs_to :business, :polymorphic => true
  belongs_to :employee, :polymorphic => true
	has_many :accounts, :dependent=>:destroy
	
	validates_uniqueness_of :model_id, :scope=>:model_type
end
