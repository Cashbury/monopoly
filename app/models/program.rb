class Program < ActiveRecord::Base
  belongs_to :program_type
  belongs_to :business
  
  has_many :campaigns,:dependent=>:destroy
  validates_presence_of :business_id, :program_type_id
end
