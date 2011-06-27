# == Schema Information
# Schema version: 20110615133925
#
# Table name: business_customers
#
#  id          :integer(4)      not null, primary key
#  business_id :integer(4)
#  user_id     :integer(4)
#  user_type   :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class BusinessCustomer < ActiveRecord::Base
  belongs_to :business
  belongs_to :user
end
