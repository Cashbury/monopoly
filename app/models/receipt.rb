class Receipt < ActiveRecord::Base
  belongs_to :business
  belongs_to :place
  belongs_to :user
  
  TYPE={:spend=>"spend"}
end
