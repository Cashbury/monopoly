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

class Image < ActiveRecord::Base
  belongs_to :uploadable, :polymorphic => true
  
  def delete_photo=(value)
    @delete_photo = !value.to_i.zero?
  end
  
  def delete_photo
    !!@delete_photo
  end
  alias_method :delete_photo?, :delete_photo
end
