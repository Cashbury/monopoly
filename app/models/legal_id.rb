class LegalId < ActiveRecord::Base
	belongs_to :legal_type
	belongs_to :user
end
