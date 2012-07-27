# == Schema Information
# Schema version: 20110615133925
#
# Table name: actions
#
#  id                  :integer(4)      not null, primary key
#  name                :string(255)
#  transaction_type_id :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#

class Action < ActiveRecord::Base
  belongs_to :transaction_type
  has_many :logs
  
  CURRENT_ACTIONS = {:engagement=>"Engagement", :redeem=>"Redeem", :withdraw=>"Withdraw", :deposit=>"Deposit", :void => "Void", :cashout => "Cashout"}

  def self.[](name)
    Action.where(:name => name).first
  end

end
