class ItemImage < Image
  belongs_to :item
  has_attached_file :photo,
                    :styles => {
                      :thumb  => "100x100>" #for fb share
                     },
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "items/:id/:style/:filename"
                    
  validates :photo_content_type, :inclusion => { :in => IMAGES_CONTENT_TYPE }
end
