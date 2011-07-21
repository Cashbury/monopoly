# == Schema Information
# Schema version: 20110615133925
#
# Table name: businesses
#
#  id                 :integer(4)      not null, primary key
#  name               :string(255)
#  description        :text
#  created_at         :datetime
#  updated_at         :datetime
#  brand_id           :integer(4)
#  mailing_address_id :integer(4)
#  billing_address_id :integer(4)
#  country_id         :string(255)
#  legal_id           :string(255)
#

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
  has_many :accounts
  #has_many :business_images,:as => :uploadable, :dependent => :destroy
  has_many :tmp_images,:as => :uploadable, :dependent => :destroy


  has_one :account_holder, :as=>:model, :dependent=> :destroy
  belongs_to :mailing_address, :class_name=>"Address" ,:foreign_key=>"mailing_address_id"
  belongs_to :billing_address, :class_name=>"Address" ,:foreign_key=>"billing_address_id"
  belongs_to :brand
  belongs_to :country
  has_and_belongs_to_many :categories
  accepts_nested_attributes_for :places, :allow_destroy => true, :reject_if => proc { |attributes| attributes['name'].blank? }
  #accepts_nested_attributes_for :business_images,:allow_destroy => true
  accepts_nested_attributes_for :tmp_images
  accepts_nested_attributes_for :mailing_address,:reject_if =>:all_blank
  accepts_nested_attributes_for :billing_address,:reject_if =>:all_blank
  attr_accessor :categories_list

  after_save :update_categories

	#validates :tag_list, :presence=>true
	validates :brand_id, :presence=>true , :numericality => true
	validates_presence_of :name
	validates_associated :places
	before_validation :clear_photos
  before_save :add_business_name_to_biz_tag_list

  def clear_photos
    self.tmp_images.each do |tmp_image|
      tmp_image.upload_type="BusinessImage"
    end
    #self.business_images.each do |image|
    #  image.destroy if image.delete_photo? && !image.photo.dirty?
    #end
  end


  # This method checks for
  # any place is set to true or not
  # @return [Boolean]
  def is_any_primary?
    self.places.each do |place|
      return place.is_primary? == true
    end
  end

 def account_holder
	  AccountHolder.where(:model_id=>self.id,:model_type=>self.class.to_s).first
  end


  #====================================================================
  private
  #====================================================================
  def update_categories
    categories.delete_all
    selected_categories = categories_list.nil? ? [] : categories_list.keys.collect{|id| Category.find(id)}
    selected_categories.each {|category| self.categories << category}
  end

  def add_business_name_to_biz_tag_list
    self.tag_list << self.name
  end

end
