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
  belongs_to :user
  belongs_to :program
  has_many :reports, :as => :reportable
  
  validates_uniqueness_of :user_id, :scope => :program_id
end