# == Schema Information
# Schema version: 20110615133925
#
# Table name: employees
#
#  id               :integer(4)      not null, primary key
#  position         :string(255)
#  employee_type_id :integer(4)
#  created_at       :datetime
#  updated_at       :datetime
#  user_id          :integer(4)
#

class Employee < ActiveRecord::Base
  set_table_name "roles_users"
  
  belongs_to :user
  belongs_to :business
  belongs_to :role
end
