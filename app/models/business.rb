class Business < ActiveRecord::Base
	acts_as_taggable
	has_many :targets
  has_many :places, :dependent => :destroy
  has_many :programs,:dependent => :destroy
  has_many :measurement_types
  has_many :engagement_types
  has_many :followers, :as=>:followed
  has_many :users, :through=>:followers
  has_many :business_customers
  has_many :users, :through=> :business_customers
  has_many :announcements
  has_many :logs
  has_many :legal_ids , :as=>:associatable
  has_many :items,:dependent => :destroy
  has_many :business_images,:as => :uploadable, :dependent => :destroy
  has_many :tmp_images,:as => :uploadable, :dependent => :destroy
  
  has_one :account_holder, :as=>:model, :dependent=> :destroy
  has_one :mailing_address, :class_name=>"Address" ,:foreign_key=>"mailing_address_id"
  has_one :billing_address, :class_name=>"Address" ,:foreign_key=>"billing_address_id"
  belongs_to :brand
  belongs_to :country
  has_and_belongs_to_many :categories
  accepts_nested_attributes_for :places, :allow_destroy => true, :reject_if => proc { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :business_images,:allow_destroy => true
  accepts_nested_attributes_for :tmp_images
  attr_accessor :categories_list

  after_save :update_categories
  
	validates :tag_list, :presence=>true
	validates :brand_id, :presence=>true , :numericality => true 
	validates_presence_of :name
	validates_associated :places
	before_validation :clear_photos
  
  def clear_photos
    self.tmp_images.each do |tmp_image|
      tmp_image.upload_type="BusinessImage"
    end
    self.business_images.each do |image|
      image.destroy if image.delete_photo? && !image.photo.dirty?
    end
  end
  
  private
  def update_categories
    categories.delete_all
    selected_categories = categories_list.nil? ? [] : categories_list.keys.collect{|id| Category.find(id)}
    selected_categories.each {|category| self.categories << category}
  end
  
end
