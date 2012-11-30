# == Schema Information
# Schema version: 20110615133925
#
# Table name: legal_types
#
#  id         :integer(4)      not null, primary key
#  name   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class LegalType < ActiveRecord::Base
  has_many :legal_ids	

  AS = {
    social_number: "Social Number",
    passport_number: "Passport Number"
  }
  
  def displayed_type
    AS[self.name.to_sym]
  end

end