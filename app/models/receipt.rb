class Receipt < ActiveRecord::Base
  belongs_to :business
  belongs_to :place
  belongs_to :user
  belongs_to :transaction
  belongs_to :log_group
  
  TYPE={:spend=>"spend"}
end
