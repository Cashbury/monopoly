class Newsletter < ActiveRecord::Base
  attr_accessible :letter_type, :name, :email, :country , :city
 
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name , :presence => true
  validates :email, :presence => true,
                    :uniqueness=> true,
                    :format   => {:with=> email_regex}


end
