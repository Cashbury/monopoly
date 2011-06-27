# == Schema Information
# Schema version: 20110615133925
#
# Table name: employee_types
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class EmployeeType < ActiveRecord::Base
  has_many :employees
  validates_presence_of :name
end
