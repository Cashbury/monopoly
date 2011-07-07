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

class PlaceImage < Image
  belongs_to :place
  
  has_attached_file :photo,
                    :styles => {
                      :thumb  => Proc.new { |instance| instance.resize_and_crop},
                      :normal => "460x320>"
                    },
                    :processors => [:cropper],
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "places/:id/:style/:filename"
                    
  validates :photo_content_type, :inclusion => { :in => IMAGES_CONTENT_TYPE }  
  def resize_and_crop
    geo = Paperclip::Geometry.from_file(photo.to_file(:original))
    min_width  = 79
    min_height = 79
    original_ratio = geo.width.fdiv(geo.height)
    desired_ratio = min_width.fdiv(min_height)
    if original_ratio < desired_ratio
      # Vertical Image
      final_width  = min_width
      final_height = final_width.fdiv(geo.width) * geo.height
      self.crop_x=0
      self.crop_y= (final_height-79).fdiv(2)
      self.crop_w=79
      self.crop_h=79
    elsif original_ratio > desired_ratio
      # Horizontal Image
      final_height = min_height
      final_width  = final_height.fdiv(geo.height) * geo.width
      self.crop_x=(final_width-79).fdiv(2)
      self.crop_y= 0
      self.crop_w=79
      self.crop_h=79
    elsif original_ratio == desired_ratio
      final_height = min_height
      final_width  = final_height.fdiv(geo.height) * geo.width      
    end
    "#{final_width.round}x#{final_height.round}!"
  end 
end
