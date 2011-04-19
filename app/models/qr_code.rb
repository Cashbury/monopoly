require 'uri'
class QrCode < ActiveRecord::Base  
  #QrCode dependent on engagement type "stamp"
  STAMP       = "Buy a product/service"
  MULTI_USE   = 1
  SINGLE_USE  = 0

  attr_accessible :related_id, :related_type, :hash_code , :status ,:code_type
  
  before_create :encrypt_code

  scope :associated_with_engagements , where(:related_type=>"Engagement")

  #def related_id 
   # return read_attribute(:related_id)
  #end
  
  def engagement
    returned_type = nil
    if self.related_type = Engagement.name
      begin 
         returned_type = Engagement.find(related_id)
      rescue
        returned_type = nil
       end
    end
    return  returned_type
  end
  
  def encrypt_code
    self.hash_code = ActiveSupport::SecureRandom.hex(10)      # 
    #unique_code = { :engagement_id => engagement.id}.to_yaml
    save_image_server_path                                        
    #self.unique_code = encrypt(unique_code)          
    self.hash_code
  end

  def qr_image 
    qr_dimension = "100x100"
    qr_dimension = "300x300" if code_type #true means multiUse
   "https://chart.googleapis.com/chart?chs=#{qr_dimension}&cht=qr&choe=UTF-8&chl="+hash_code
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
      engagement.try(:program).try(:business).try(:name) 
    end
  end

  def save_image_server_path
		if !File.exists?(File.join("#{Rails.public_path}","images","qrcodes"))
			Dir.mkdir(File.join("#{Rails.public_path}","images","qrcodes"))
		end
    open("#{Rails.public_path}/images/qrcodes/#{hash_code}.png","wb")  do |io|
      io << open(URI.parse(qr_image)).read
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
