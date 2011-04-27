class Program < ActiveRecord::Base
  belongs_to :program_type
  belongs_to :business
  
  has_many :campaigns,:dependent=>:destroy
  validates_presence_of :business_id, :program_type_id
  validates_uniqueness_of :program_type_id, :scope=>[:business_id]  
  
  def program_type_name
    return program_type.name
  end
end
