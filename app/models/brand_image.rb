require "#{Rails.root}/lib/paperclip_processors/cropper.rb" # required to make cropping work.
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
class BrandImage < Image
  belongs_to :brand
  has_attached_file :photo,
                    :styles => {
                      :thumb  => "100x100>", #for fb share
                      :normal => Proc.new { |instance| instance.resize }
                    },
                    :processors => [:cropper] ,
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "brands/:id/:style/:filename"
  validates :photo_content_type, :inclusion => { :in => IMAGES_CONTENT_TYPE }
end
