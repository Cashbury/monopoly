# == Schema Information
# Schema version: 20101218032208
#
# Table name: accounts
#
#  id         :integer         not null, primary key
#  points     :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Account < ActiveRecord::Base
  belongs_to :account_holder
  belongs_to :campaign
  belongs_to :measurement_type
  
  has_many :reports, :as => :reportable
  
  validates_uniqueness_of :account_holder_id, :scope => :campaign_id
  validates_numericality_of :amount
end