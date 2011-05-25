class Action < ActiveRecord::Base
  belongs_to :transaction_type
  has_many :logs
  
  CURRENT_ACTIONS={:engagement=>"Engagement", :redeem=>"Redeem"}
end