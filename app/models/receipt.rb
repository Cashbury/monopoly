class Receipt < ActiveRecord::Base
  belongs_to :business
  belongs_to :place
  belongs_to :user
  belongs_to :transaction
  belongs_to :log_group
  belongs_to :campaign, :foreign_key=>"spend_campaign_id"
  
  TYPE={:spend=>"spend"}
end
