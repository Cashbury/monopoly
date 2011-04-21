class TmpUpload < ActiveRecord::Base
  belongs_to :uploadable, :polymorphic => true
  has_attached_file :photo,
                    :url => '/uploads/:id/:style.:extension',
                    :path => ":rails_root/tmp/uploads/:id_:style.:extension"

  after_create do |tmp_upload|
    if ENABLE_DELAYED_UPLOADS
      Delayed::Job.enqueue(MoveToCloud.new(tmp_upload.id), 0, Time.now, CURRENT_IP)
    else
      MoveToCloud.new(self.id)
    end
  end
  
  def move_to_cloud
    upload_class = eval(self.upload_type)
    upload = upload_class.new
    upload.attributes = self.attributes
    upload.uploadable = self.uploadable
    upload.photo = self.photo
    upload.photo_file_name = self.photo_file_name
    
    upload_valid = upload.valid?
    Image.transaction do
      upload.save!
      self.photo = nil
      self.save!
      self.destroy
    end
  #rescue=> e
  #  logger.info "[Delayed Job][#{Time.now.utc}] Job Failed for TmpUpload : #{self.id}"
  #  raise e
  end

end
