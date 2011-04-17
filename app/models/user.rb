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
   
  has_many :templates
  
	def has_account_with_campaign?(campaign_id)
	  acch=AccountHolder.where(:model_id=>self.id,:model_type=>self.class.to_s).first
		!acch.nil? && !acch.accounts.where(:campaign_id=>campaign_id).empty?
	end
	
	def auto_enroll_at(places)
	  begin
      ids=places.collect{|p| p.business_id}
      businesses=Business.where(:id=>ids)
      businesses.each do |business|
        business.programs.each do |program|
          program.campaigns.each do |campaign|
            unless self.has_account_with_campaign?(campaign.id)
              acch=AccountHolder.create!(:model_id=>self.id,:model_type=>self.class.to_s)
              acch.accounts << Account.create!(:user_id=>self.id,:campaign_id=>campaign.id,:amount=>campaign.initial_points,:measurement_type=>campaign.measurement_type)
              acch.save
            end
          end
        end
      end
    rescue Exception=>e
      logger.error "Exception #{e.class}: #{e.message}"
    end
	end
	
	def account_holder
	  AccountHolder.where(:model_id=>self.id,:model_type=>"User")
	end
	
	def snapped_qrcode(qr_code_hash,place_id,lat,lng)
    qr_code=QrCode.where(:hash_code=>qr_code_hash,:related_type=>"Engagement")
    engagement=Engagement.find(qr_code.related_id)
    campaign=engagement.campaign
    account=Account.where(:account_holder_id=>self.account_holder.id,:campaign_id=>campaign.id).first
    date=Date.today.to_s
    Account.transaction do
      qr_code.scan
      if account.nil?
        acch=AccountHolder.create!(:model_id=>self.id,:model_type=>self.class.to_s)
        account=Account.create!(:user_id=>self.id,:campaign_id=>campaign.id,:amount=>campaign.initial_points,:measurement_type=>campaign.measurement_type)
        acch.accounts << account
        acch.save
      end
      account.increment!(:amount,engagement.amount)
      log_group=LogGroup.create!(:created_on=>date)
      log_group << Log.create!(:user_id       =>self.id,
                               :log_type      =>Log::LOG_TYPES[0], #snap
                               :engagement_id =>engagement.id,
                               :business_id   =>account.campaign.program.business.id,
                               :place_id      =>place_id,
                               :amount        =>engagement.amount,
                               :amount_type   =>account.measurement_type,
                               :lat           =>lat,
                               :lng           =>lng,
                               :created_on    =>date)
      log_group.save!                                
    end 
    [account,campaign,campaign.program,engagement.amount]
	end
	
	def is_engaged_to?(business_id)
		!self.user_actions.where(:business_id=>business_id).empty?
	end
	
	def ensure_authentication_token!
    reset_authentication_token! if authentication_token.blank?
  end
  
end
