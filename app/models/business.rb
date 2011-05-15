class Business < ActiveRecord::Base
	acts_as_taggable
	has_many :targets
  has_many :places, :dependent => :destroy
  has_many :programs,:dependent => :destroy
  has_many :measurement_types
  has_many :engagement_types
  has_many :followers, :as=>:followed
  has_many :users, :through=>:followers
  has_many :announcements
  has_many :logs
  has_many :legal_ids , :as=>:associatable
  has_many :items
  has_many :business_images,:as => :uploadable, :dependent => :destroy
  
  has_one :account_holder, :as=>:model
  belongs_to :mailing_address, :class_name=>"Address" ,:foreign_key=>"mailing_address_id"
  belongs_to :billing_address, :class_name=>"Address" ,:foreign_key=>"billing_address_id"
  belongs_to :brand
  belongs_to :country
  has_and_belongs_to_many :categories
  accepts_nested_attributes_for :places, :allow_destroy => true, :reject_if => proc { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :business_images
  accepts_nested_attributes_for :mailing_address
  accepts_nested_attributes_for :billing_address
  attr_accessor :categories_list

  after_save :update_categories
  
	validates :tag_list, :presence=>true
	validates :brand_id, :presence=>true , :numericality => true 
	validates_presence_of :name
	validates_associated :places
	
  private
  def update_categories
    categories.delete_all
    selected_categories = categories_list.nil? ? [] : categories_list.keys.collect{|id| Category.find(id)}
    selected_categories.each {|category| self.categories << category}
  end
  
end
