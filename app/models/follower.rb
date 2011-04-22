class Follower < ActiveRecord::Base
  belongs_to :business
  belongs_to :user
  
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :user_email,:uniqueness=> true,
                        :format   => {:with=> email_regex}

end
