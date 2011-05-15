class BrandImage < Image
  belongs_to :brand
  has_attached_file :photo,
                    :styles => {
                      :normal  => "81x52>" 
                    },
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "brands/:id/:style/:filename"
                    
  validates :photo_content_type, :inclusion => { :in => IMAGES_CONTENT_TYPE }
end
