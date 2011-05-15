class TmpImage < ActiveRecord::Base
  belongs_to :uploadable, :polymorphic => true
  has_attached_file :photo,
                    :url => '/uploads/:id/:style.:extension',
                    :path => ":rails_root/tmp/uploads/:filename"                    
                                     
  after_create do |tmp_upload|
    Delayed::Job.enqueue(MoveToCloud.new(tmp_upload.id), 0, Time.now)
  end                   
                    
  def move_to_cloud
    upload_class = eval(self.upload_type)
    upload = upload_class.new
    upload.attributes = self.attributes
    upload.uploadable = self.uploadable
    upload.photo = self.photo
    upload_valid = upload.valid?
    Image.transaction do
      upload.save!
      self.photo = nil
      self.save!
      self.destroy
    end
  rescue=> e
    raise e
  end                    
end
