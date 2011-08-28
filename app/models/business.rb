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
  before_validation :clear_photos
  before_save :add_business_name_to_biz_tag_list

  #validates :tag_list, :presence=>true
  validates :brand_id, :presence=>true , :numericality => true
  validates_presence_of :name
  validates_associated :places


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
  
  def has_spend_based_campaign?
   self.programs.joins(:campaigns).where("campaigns.ctype=#{Campaign::CTYPE[:spend]}").size > 0
    #Campaign.joins(:program=>:business).where("businesses.id=#{business.id} and campaigns.ctype=#{Campaign::CTYPE[:spend]}").limit(1).size > 0
  end
  
  def spend_based_campaign
    Campaign.joins(:program=>:business).where("businesses.id=#{self.id} and campaigns.ctype=#{Campaign::CTYPE[:spend]}").limit(1).first
  end
  
  def account_holder
	  AccountHolder.where(:model_id=>self.id,:model_type=>self.class.to_s).first
  end

  def currency_symbol
    self.currency_code.present? ? ISO4217::Currency.from_code(self.currency_code).try(:symbol) : "$"
  end
  
  def country_flag
    "#{COUNTRIES_FLAGS_PATH}#{self.country.iso2.to_s.downcase}.png" if self.country.present? and self.country.iso2.present?
  end
  
  def list_campaigns
    self.programs
        .joins([:program_type,[:campaigns=>[:accounts=>:account_holder]]])
        .where("account_holders.model_id=#{self.id} and account_holders.model_type='#{self.class.to_s}'")
        .select("campaigns.name as c_name, program_types.name as pt_name, accounts.amount as biz_balance, campaigns.id as c_id")
  end
  
  NEW_CUSTOMER=1
  RETURNING_CUSTOMER=2
 
  def list_all_enrolled_customers(type_id)
    case type_id
      when NEW_CUSTOMER #new customers are those who are enrolled (have accounts @biz) but not engaged yet
        ids=self.users.collect{|u| u.id}.join(',')
        self.programs.joins(:campaigns=>[:accounts=>:account_holder]) 
                     .joins("INNER JOIN users ON account_holders.model_id=users.id")
                     .where("account_holders.model_type='User' and users.id NOT IN (#{ids})")                     
                     .group("users.id")
                     .select("0 as total, (CONCAT(users.first_name, ' ', users.last_name )) as full_name, users.email")
                     .order("total DESC")
      when RETURNING_CUSTOMER #customers that have been engaged with the biz before
        self.users
        .joins(:logs)
        .group("logs.user_id")
        .select("count(*) as total, (CONCAT(users.first_name, ' ', users.last_name )) as full_name, users.email")
        .order("total DESC")
    else
      ids=self.users.collect{|u| u.id}.join(',')
      new_customers=self.programs.joins(:campaigns=>[:accounts=>:account_holder]) 
                                 .joins("INNER JOIN users ON account_holders.model_id=users.id")
                                 .where("account_holders.model_type='User' and users.id NOT IN (#{ids})")                     
                                 .group("users.id")
                                 .select("0 as total,users.id as user_id,(CONCAT(users.first_name, ' ', users.last_name )) as full_name, users.email")
                                 .order("total DESC")
      returning_customers=self.users
                              .joins(:logs)
                              .group("logs.user_id")
                              .select("users.id as user_id, count(*) as total, (CONCAT(users.first_name, ' ', users.last_name )) as full_name, users.email")
                              .order("total DESC")                         
      result=(new_customers | returning_customers).uniq_by { |i| i.user_id }
    end            
    
  end


  def self.search_by_brand_name(name)
    if name.present?
      joins(:brand).where([" brands.name  like ?", "%#{name}%"])
    else
      scoped
    end
  end

  def self.search_by_name(name)
    if name.present?
      where([" businesses.name  like ?", "%#{name}%"])
    else
      scoped
    end
  end

  def self.search_by_address(column, address_id)
    if address_id.present?
      joins(:mailing_address).where(["addresses.#{column}=?",address_id])
    else
      scoped
    end
  end
  
  def set_legal_ids(legal_types, legal_ids)
    legal_types.each_with_index do |legal_type_id, index|
      if legal_ids[index].present? and legal_type_id.present?
        LegalId.find_or_create_by_legal_type_id_and_associatable_id_and_associatable_type(:id_number=>legal_ids[index],:associatable_id=>self.id,:associatable_type=>"Business",:legal_type_id=>legal_type_id)
      end
    end
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
