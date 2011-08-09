# == Schema Information
# Schema version: 20110615133925
#
# Table name: items
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  description  :string(255)
#  price        :decimal(10, 3)
#  business_id  :integer(4)
#  available    :boolean(1)      default(TRUE)
#  expiry_date  :date
#  created_at   :datetime
#  updated_at   :datetime
#  product_code :string(255)
#  cost         :decimal(20, 3)
#

class Item < ActiveRecord::Base
	belongs_to :business
	has_many :item_places 
	has_many :places , :through => :item_places
  has_and_belongs_to_many :rewards
	has_one :item_image, :as => :uploadable, :dependent => :destroy
	has_many :engagements
	
	accepts_nested_attributes_for :places
	accepts_nested_attributes_for :item_image
	
	validates_presence_of :name	
	after_update :reprocess_photo
	
	def self.list_engagements_items(business_id)
	  joins(:engagements=>[:campaign=>[:program=>:business]])
    .where("businesses.id=#{business_id} and ((campaigns.end_date IS NOT null AND '#{Date.today}' BETWEEN campaigns.start_date AND campaigns.end_date) || '#{Date.today}' >= campaigns.start_date)")
    .select("engagements.id as engagement_id, items.id as item_id, items.name as item_name")
  end
  
	private  
  def reprocess_photo  
    if !self.item_image.nil? and self.item_image.cropping?
      self.item_image.photo.reprocess!
      self.item_image.save
    end
  end  
end
