require 'uri'
class QrCode < ActiveRecord::Base  
  #QrCode dependent on engagement type "stamp"
  belongs_to :associatable,:polymorphic => true #engagement, place, business
  
  has_one :qr_code_image, :as => :uploadable, :dependent => :destroy
  
  STAMP       = "Buy a product/service"
  MULTI_USE   = 1
  SINGLE_USE  = 0
  # has_attached_file :image, 
  #                   :storage => :s3,
  #                   :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
  #                   :path => "qrcodes/:id/:filename"
  
  attr_accessible :associatable_id, :associatable_type, :hash_code , :status ,:code_type

  before_create :encrypt_code
  before_destroy :destroy_image
  after_create :upload_image
  scope :associated_with_engagements , where(:associatable_type=>"Engagement")
  
  def destroy_image
    self.qr_code_image.destroy
  end

  def set_qr_code_image
    begin
      io = open(URI.parse(qr_image))
      io.original_filename="#{hash_code}.png"
      @image = QrCodeImage.new()
      @image.uploadable = self
      @image.photo= io.original_filename.blank? ? nil : io
    rescue Timeout::Error
      @image = nil
    end
  end
  
  def upload_image
    @image.save!
  end
  
  def encrypt_code
    self.hash_code = ActiveSupport::SecureRandom.hex(10)      # 
    #unique_code = { :engagement_id => engagement.id}.to_yaml
    #save_image_server_path 
    set_qr_code_image                                      
    #self.unique_code = encrypt(unique_code)          
    self.hash_code
  end

  def qr_image 
    qr_dimension = "100x100"
    qr_dimension = "300x300" if code_type #true means multiUse
   "https://chart.googleapis.com/chart?chs=#{qr_dimension}&cht=qr&choe=UTF-8&chl="+hash_code
  end

  def qr_image_url
    QrCodeImage.where(:uploadable_id=>self.id).url(:original)
  end

  def scan
   unless code_type #singleUse
    self.status = 0
    save!
   end
   #have add logger methods to logg here
  end

  def engagement
    self.associatable if self.associatable.class.to_s == "Engagement"
  end
  
  def business_name
    if engagement.blank?
      "NA"
    else
      engagement.try(:program).try(:business).try(:name) 
    end
  end

  #def save_image_server_path
	#	if !File.exists?(File.join("#{Rails.public_path}","images","qrcodes"))
	#		Dir.mkdir(File.join("#{Rails.public_path}","images","qrcodes"))
	#	end
  #  open("#{Rails.public_path}/images/qrcodes/#{hash_code}.png","wb")  do |io|
  #    io << open(URI.parse(qr_image )).read
  #  end
  #end
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
