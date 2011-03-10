require 'uri'
class QrCode < ActiveRecord::Base  
  #QrCode dependent on engagement type "stamp"
  STAMP       = "Buy a product/service"
  MULTI_USE   = 1
  SINGLE_USE  = 0

  attr_accessible :place_id , :engagement_id , :hash_code , :point , :status ,:code_type

  belongs_to :place
  belongs_to :engagement

  before_save :encrypt_code

  def encrypt_code
    self.hash_code = ActiveSupport::SecureRandom.hex(10)
    #save_image(self.hash_code)
    unique_code = { :engagement_id => engagement.id}.to_yaml
    self.unique_code = encrypt(unique_code)
    self.hash_code
  end

  def qr_image 
   "http://qrcode.kaywa.com/img.php?s=6&t=p&d="+URI.escape(hash_code,Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
   
   "https://chart.googleapis.com/chart?chs=150x150&cht=qr&choe=UTF-8&chl="+hash_code

  end

  def self.code(engagement_id, place_id)
    where({:place_id=>place_id , :engagement_id=>engagement_id }).first 
  end


  def scan
   unless code_type #singleUse
    self.status = 0
    save!
   end

   #have add logger methods to logg here
  end


  def business_name
   engagement.business.name 
  end

  def save_image(hash_code)
    url = self.class.image(hash_code) 
    open("#{RAILS_ROOT}/public/images/qrcodes/#{hash_code}.png","wb")  do |io|
      io << open(URI.parse(url.to_s)).read
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
