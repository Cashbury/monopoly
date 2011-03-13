require 'uri'
class QrCode < ActiveRecord::Base  
  #QrCode dependent on engagement type "stamp"
  STAMP       = "Buy a product/service"
  MULTI_USE   = 1
  SINGLE_USE  = 0

  attr_accessible :place_id , :engagement_id , :hash_code , :point , :status ,:code_type

  belongs_to :place
  
	has_many :users_snaps
	
  belongs_to :engagement
  
  before_create :encrypt_code

  scope :associated_with_engagements , where("qr_codes.engagement_id IS NOT NULL")

  def encrypt_code
    self.hash_code = ActiveSupport::SecureRandom.hex(10)      # 
    #unique_code = { :engagement_id => engagement.id}.to_yaml
    self.save_image                                           #save image to server
    #self.unique_code = encrypt(unique_code)                   # generates a unique code :)
    self.hash_code
  end

  def qr_image 
   "https://chart.googleapis.com/chart?chs=150x150&cht=qr&choe=UTF-8&chl="+hash_code
  end


  def scan
   unless code_type #singleUse
    self.status = 0
    save!
   end
   #have add logger methods to logg here
  end


  def business_name
    if engagement.blank?
      "NA"
    else
      engagement.business.name 
    end
  end

  def save_image
    open("#{Rails.public_path}/images/qrcodes/#{hash_code}.png","wb")  do |io|
      io << open(URI.parse( self.qr_image )).read
    end
  end




  private #=============================================================

  def encrypt(text)
    @key = OpenSSL::Digest::SHA256.new("hassan").digest
    @cipher = OpenSSL::Cipher::Cipher.new('aes-256-cbc')
    @cipher.encrypt
    @cipher.key = @key

    @cipher.update(text) 
    @cipher.final
  end

  def decrypt(text)
    @cipher.decrypt
    @cipher.key = @key

    @cipher.update(text) 
    @cipher.final
  end

end
