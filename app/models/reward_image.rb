require "#{Rails.root}/lib/paperclip_processors/cropper.rb" # required to make cropping work.
class RewardImage < Image
  belongs_to :reward
  
  has_attached_file :photo,
                    :styles => {
                      :thumb  => "100x100>", #for fb share
                      :normal => Proc.new { |instance| instance.resize }
                    },
                    :processors => [:cropper] ,
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "rewards/:id/:style/:filename"
                    
  validates :photo_content_type, :inclusion => { :in => IMAGES_CONTENT_TYPE }
end
