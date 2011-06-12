class Follower < ActiveRecord::Base
  belongs_to :business,:polymorphic => true
  belongs_to :user,:polymorphic => true
  belongs_to :place,:polymorphic => true
  
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :user_email,:uniqueness=> true,
                        :format   => {:with=> email_regex}

end