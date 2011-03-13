class ProgramType < ActiveRecord::Base
	has_many :programs,:dependent=>:destroy,:foreign_key=>'program_type_id'
end
