class AccountHolder < ActiveRecord::Base
  belongs_to :user, :polymorphic => true
  belongs_to :business, :polymorphic => true
  belongs_to :employee, :polymorphic => true
	has_many :accounts, :dependent=>:destroy
	
	validates_uniqueness_of :model_id, :scope=>:model_type
end
