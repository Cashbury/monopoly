# == Schema Information
# Schema version: 20110615133925
#
# Table name: followers
#
#  id                :integer(4)      not null, primary key
#  user_id           :integer(4)
#  user_email        :string(255)
#  user_phone_number :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  followed_id       :integer(4)
#  followed_type     :string(255)
#  biz_name          :string(255)
#  city              :string(255)
#

class Follower < ActiveRecord::Base
  belongs_to :business,:polymorphic => true
  belongs_to :user,:polymorphic => true
  belongs_to :place,:polymorphic => true
  
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :user_email,:uniqueness=> true,
                        :format   => {:with=> email_regex}

end
