# == Schema Information
# Schema version: 20101218032208
#
# Table name: users
#
#  id                   :integer         primary key
#  email                :string(255)     default(""), not null
#  encrypted_password   :string(128)     default(""), not null
#  password_salt        :string(255)     default(""), not null
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :timestamp
#  sign_in_count        :integer         default(0)
#  current_sign_in_at   :timestamp
#  last_sign_in_at      :timestamp
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  created_at           :timestamp
#  updated_at           :timestamp
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,:token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,:confirmable


  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:full_name,:authentication_token
  
  has_many :accounts
  has_many :brands
  has_many :user_actions 
  has_many :templates
  
	def has_account_with_program?(program_id)
		!self.accounts.where(:program_id=>program_id).empty?
	end
	
	def is_engaged_to?(business_id)
		!self.user_actions.where(:business_id=>business_id).empty?
	end
	
	def ensure_authentication_token!
    reset_authentication_token! if authentication_token.blank?
  end
  
end
