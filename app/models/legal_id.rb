class LegalId < ActiveRecord::Base
	belongs_to :legal_type
	belongs_to :user,:polymorphic => true
  belongs_to :business,:polymorphic => true
end
