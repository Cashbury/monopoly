class Log < ActiveRecord::Base
	belongs_to :user
	belongs_to :place
	belongs_to :business
	belongs_to :engagement
	belongs_to :reward
	belongs_to :log_group
	 
	validates_numericality_of :amount, :frequency, :lat, :lng
	
	LOG_TYPES={
	  0 => :snap,
	  1 => :redeem
	}
	scope :snaps_logs, where(:log_type=>LOG_TYPES[0])
	scope :redeems_logs, where(:log_type=>LOG_TYPES[1])
end
