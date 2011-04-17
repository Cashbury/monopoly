class AccountHolder < ActiveRecord::Base
	has_many :accounts
	validates_uniqueness_of :model_id, :scope=>:model_type
end
