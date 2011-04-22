class Employee < ActiveRecord::Base
  belongs_to :user
  belongs_to :employee_type
  
  has_one :account_holder, :as=>:model
end
