# == Schema Information
# Schema version: 20110615133925
#
# Table name: legal_types
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class LegalType < ActiveRecord::Base
	has_many :legal_ids
end
