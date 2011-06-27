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
  belongs_to :user
  belongs_to :employee_type
  
  has_one :account_holder, :as=>:model
end
