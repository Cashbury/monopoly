class Log < ActiveRecord::Base
	belongs_to :user
	belongs_to :place
	belongs_to :business
	belongs_to :engagement
	belongs_to :reward
	belongs_to :log_group
	 
	validates_numericality :amount, :frequency, :lat, :lng
end
