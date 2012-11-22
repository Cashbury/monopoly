# == Schema Information
# Schema version: 20110615133925
#
# Table name: images
#
#  id                 :integer(4)      not null, primary key
#  uploadable_id      :integer(4)
#  uploadable_type    :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#  upload_type        :string(255)
#
class UserImage < Image
  belongs_to :user
  
  has_attached_file :photo,
                    :styles => {                      
                      :large => "196x196>"
                    },
                    :processors => [:cropper],
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "users/:id/:style/:filename"
                    
  validates :photo_content_type, :inclusion => { :in => IMAGES_CONTENT_TYPE } , :if => Proc.new {|i| i.photo.present? } 
  validates_attachment_size :photo, :less_than => 3.megabytes, :if => Proc.new {|i| i.photo.present? }
end
