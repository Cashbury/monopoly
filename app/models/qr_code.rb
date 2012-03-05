# == Schema Information
# Schema version: 20110615133925
#
# Table name: qr_codes
#
#  id                :integer(4)      not null, primary key
#  hash_code         :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  code_type         :boolean(1)
#  status            :boolean(1)
#  exported          :boolean(1)
#  associatable_id   :integer(4)
#  associatable_type :string(255)
#

require 'open-uri'
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
  PRE_PRINTED_SIZE= 1
  WEB_SIZE=2

  USER_TYPE="User"
  ENGAGEMENT_TYPE="Engagement"

  SINGLE_USE_PRE_PRINTED_SIZE = "240x240"
  MULTI_USE_OR_WEB_SIZE       = "300x300"

  ISSUED_BY_SYSTEM = 0

  attr_accessible :associatable_id, :associatable_type, :hash_code , :status ,:code_type, :size
  before_create :encrypt_code
  before_destroy :destroy_image
  after_create :upload_image

  scope :associated_with_engagements , where(:associatable_type=>QrCode::ENGAGEMENT_TYPE)
  scope :associated_with_users , where(:associatable_type=>QrCode::USER_TYPE)

  default_scope :order => 'created_at DESC'

  cattr_reader :per_page
  @@per_page = 20
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
    self.hash_code = "C$::" + ActiveSupport::SecureRandom.hex(10)      # 
    #unique_code = { :engagement_id => engagement.id}.to_yaml
    #save_image_server_path 
    set_qr_code_image                                      
    #self.unique_code = encrypt(unique_code)          
    self.hash_code
  end

  def qr_image
    qr_dimension = SINGLE_USE_PRE_PRINTED_SIZE if !size && !code_type
    qr_dimension = MULTI_USE_OR_WEB_SIZE if size || code_type #true means multiUse  
    "https://chart.googleapis.com/chart?chs=#{qr_dimension}&cht=qr&choe=UTF-8&chl="+hash_code   
  end

  def qr_image_url
    QrCodeImage.where(:uploadable_id=>self.id).url(:original)
  end

  def scan
    unless code_type #singleUse
      self.status = 0
      save!
      #if it is a user's code, after each scan we auto reissue a new single use one
      QrCode.create(:code_type => QrCode::SINGLE_USE, :status=>1, :associatable_id=>self.associatable.id,:associatable_type=>QrCode::USER_TYPE,:size=>self.size) if self.user    
    end
    #have add logger methods to logg here
  end

  def engagement
    self.associatable if self.associatable.class.to_s == QrCode::ENGAGEMENT_TYPE
  end

  def user
    self.associatable if self.associatable.class.to_s == QrCode::USER_TYPE
  end

  def business_name
    if engagement.blank?
      "NA"
    else
      engagement.try(:program).try(:business).try(:name) 
    end
  end

  def created_by
    (self.issued_by==0) ? "System" :  User.find(self.issued_by).full_name.capitalize
  end

  def self.create_for_campaign(campaign)
    engagement = campaign.engagements.first
    business = campaign.program.business
    QrCode.create(:code_type => QrCode::MULTI_USE, 
                  :business => business,
                  :associatable_id => engagement.id,
                  :associatable_type => QrCode::ENGAGEMENT_TYPE,
                  :status => true, 
                  :issued_by => ISSUED_BY_SYSTEM,
                  :size => WEB_SIZE)
  end

  def single_use?
    !self.code_type
  end

  def multi_use?
    self.code_type
  end

  def deactivate
    self.status = 0
    self.save!
  end

  # Reissue new Qrcode
  def reissue
      raise "this QrCode should be first associated to a user" unless self.user
      self.deactivate
      QrCode.create(:code_type => self.code_type,
                    :status=>1,
                    :associatable_id=>self.associatable.id,
                    :associatable_type=>QrCode::USER_TYPE,
                    :size=>self.size)
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
