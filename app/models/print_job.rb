# == Schema Information
# Schema version: 20110615133925
#
# Table name: print_jobs
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  ran        :integer(4)
#  log        :text
#  created_at :datetime
#  updated_at :datetime
#  display    :boolean(1)
#

class PrintJob < ActiveRecord::Base
end
