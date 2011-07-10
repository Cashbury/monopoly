class LoginMethod < ActiveRecord::Base
  attr_accessible :name

  AS = {
    :facebook           =>"facebook",
    :email_and_password =>"email_and_password",
    :phone_and_password =>"phone_and_password",
    :qrcode             => "qrcode"
  }
  has_many :login_methods_users
  has_many :users, :through=>"login_methods_users"
end
