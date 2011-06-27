# == Schema Information
# Schema version: 20110615133925
#
# Table name: payment_gateways
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class PaymentGateway < ActiveRecord::Base
  has_many :accounts
  validates_presence_of :name
end
