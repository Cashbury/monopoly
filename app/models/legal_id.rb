# == Schema Information
# Schema version: 20110615133925
#
# Table name: legal_ids
#
#  id                :integer(4)      not null, primary key
#  id_number         :integer(4)
#  legal_type_id     :integer(4)
#  created_at        :datetime
#  updated_at        :datetime
#  user_id           :integer(4)
#  associatable_id   :integer(4)
#  associatable_type :string(255)
#

class LegalId < ActiveRecord::Base
	belongs_to :legal_type
  belongs_to :associatable,:polymorphic => true #user, business
end
