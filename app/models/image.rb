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
