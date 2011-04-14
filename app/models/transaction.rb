class Transaction < ActiveRecord::Base
	validates_presence_of :from_account, :to_account
end
