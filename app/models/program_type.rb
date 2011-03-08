class ProgramType < ActiveRecord::Base
	has_many :programs,:dependent=>:destroy,:foreign_key=>'type_id'
end
