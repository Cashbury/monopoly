require 'uri'
class QrCode < ActiveRecord::Base
  belongs_to :place
  belongs_to :engagement, :dependent => :destroy

  before_save :encrypt_code

  def encrypt_code
    self.hash_code = ActiveSupport::SecureRandom.hex(50)
    save_image(self.hash_code)
    self.hash_code
  end

  def self.encrypt(text)
    @key = OpenSSL::Digest::SHA256.new("hassan").digest
    @cipher = OpenSSL::Cipher::Cipher.new('aes-256-cbc')
    @cipher.encrypt
    @cipher.key = @key

    @cipher.update(text) 
    @cipher.final
  end

  def self.decrypt(text)
    @cipher.decrypt
    @cipher.key = @key

    @cipher.update(text) 
    @cipher.final
  end
  

  def self.image(hash)
   "http://qrcode.kaywa.com/img.php?s=6&t=p&d="+URI.escape(hash,Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end

  def self.code(engagement_id, place_id)
    where({:place_id=>place_id , :engagement_id=>engagement_id }).first 
  end

  def save_image(hash_code)
    url = self.class.image(hash_code) 
    open("#{RAILS_ROOT}/public/images/qrcodes/#{hash_code}.png","wb")  do |io|
      io << open(URI.parse(url)).read
    end
  end
end
