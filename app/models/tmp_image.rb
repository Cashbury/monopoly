# == Schema Information
# Schema version: 20110615133925
#
# Table name: tmp_images
#
#  id                 :integer(4)      not null, primary key
#  uploadable_id      :integer(4)
#  uploadable_type    :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer(4)
#  upload_type        :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

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
