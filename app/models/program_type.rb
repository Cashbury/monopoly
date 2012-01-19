# == Schema Information
# Schema version: 20110615133925
#
# Table name: program_types
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ProgramType < ActiveRecord::Base
	has_many :programs,:dependent=>:destroy,:foreign_key=>'program_type_id'
	
	AS={
	  :marketing=>"Marketing",
	  :money=>"Money"
	}

  def self.[](name)
    ProgramType.where(:name => name).first
  end

end
