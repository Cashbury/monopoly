# == Schema Information
# Schema version: 20110615133925
#
# Table name: programs
#
#  id              :integer(4)      not null, primary key
#  program_type_id :integer(4)
#  business_id     :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#  name            :string(255)
#  is_started      :boolean(1)
#

class Program < ActiveRecord::Base
  belongs_to :program_type
  belongs_to :business
  has_many :accounts
  has_many :campaigns,:dependent=>:destroy
  validates_presence_of :business_id, :program_type_id
  validates_uniqueness_of :program_type_id, :scope=>[:business_id]  
  
  scope :running_campaigns, where("#{Date.today} > campaigns.start_date && #{Date.today} < campaigns.end_date")
  
  def program_type_name
    return self.program_type.name
  end
end
