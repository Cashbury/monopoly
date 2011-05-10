class PlaceImage < Image
  belongs_to :place
  
  has_attached_file :photo,
                    :styles => {
                      :thumb  => "100x100>"
                    },
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "places/:id/:style/:filename"
                    
  validates :photo_content_type, :inclusion => { :in => IMAGES_CONTENT_TYPE }
end
