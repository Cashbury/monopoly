class Brand < ActiveRecord::Base
  belongs_to :user
  has_many :businesses
  has_one :brand_image, :as => :uploadable, :dependent => :destroy
  #process_in_background :photo               
  #def validate
   # self.errors.add(:photo_content_type, I18n.t("messages.uploads.not_supported") + " (#{IMAGES_CONTENT_TYPE_NAME.join(", ")}).") if self.photo_file_name && !IMAGES_CONTENT_TYPE.include?(MIME::Types.type_for(self.photo_file_name).to_s)
  #end
                    
  # validates_attachment_presence :photo
  # validates_attachment_size :photo, :less_than => 5.megabytes
  # validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']

end
