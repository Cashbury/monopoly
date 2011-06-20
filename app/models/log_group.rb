# == Schema Information
# Schema version: 20110615133925
#
# Table name: log_groups
#
#  id         :integer(4)      not null, primary key
#  created_on :date
#  created_at :datetime
#  updated_at :datetime
#

class LogGroup < ActiveRecord::Base
	has_many :logs
end
