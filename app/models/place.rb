class Place < ActiveRecord::Base
  include Geokit::Geocoders
	acts_as_mappable  :lng_column_name => :long
	acts_as_taggable
  belongs_to :business
  belongs_to :place_type
  belongs_to :address
  has_many :item_places
  has_many :items , :through => :item_places, :dependent => :destroy
  has_and_belongs_to_many :amenities
  has_and_belongs_to_many :campaigns
  has_many :qr_codes,:as=>:associatable, :dependent => :destroy
  has_many :open_hours, :dependent => :destroy
  has_many :followers, :as=>:followed
  has_many :place_images,:as => :uploadable, :dependent => :destroy
  has_many :tmp_images,:as => :uploadable, :dependent => :destroy
  
  accepts_nested_attributes_for :tmp_images
  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :place_images,:allow_destroy=>true
  accepts_nested_attributes_for :items
  
  attr_accessible :name, :long, :lat, :description, :business, :time_zone,:tag_list,:place_images_attributes,:address_attributes , :items_attributes, :tmp_images_attributes
  attr_accessor :items_list
  validates_presence_of :name, :long, :lat 
  validates :address, :presence=>true
  validates_numericality_of :long,:lat
  validates_associated :address
   
  scope :with_address, order("places.name desc")
                      .joins(:address=>[:city,:country])
                      .select("places.*,addresses.zipcode,addresses.neighborhood,addresses.street_address,countries.name as country_name")
  before_save :add_amenities_name_and_place_name_to_place_tag_lists
  after_save :update_items
  before_validation :clear_photos
  
  def clear_photos
    self.tmp_images.each do |tmp_image|
      tmp_image.upload_type="PlaceImage"
    end
    self.place_images.each do |image|
      image.destroy if image.delete_photo? && !image.photo.dirty?
    end
  end
  def is_open?
    current_datetime=DateTime.now.in_time_zone(self.time_zone)
    !self.open_hours.where(["open_hours.day_no= ? and open_hours.from <= ? and open_hours.to >= ?",current_datetime.wday,current_datetime, current_datetime]).empty?
  end
  def get_city_given_geoloacation(lat,lng)
    res=Geokit::Geocoders::MultiGeocoder.reverse_geocode([lat,lng])
    if res.city
      city=City.where(:name=>res.city).first
    elsif res.full_address
      keywords=res.full_address.downcase.chomp.split(",")
      query_string=""
      keywords.each_with_index do |k,index| 
        query_string+="lower(name) LIKE '%#{k.lstrip.rstrip}%'"
        query_string+=" OR " unless index==keywords.size-1
      end
    end
    city=City.where(query_string).first
  end  
  private
  def add_amenities_name_and_place_name_to_place_tag_lists
    self.amenities.each do |amenity|
      self.tag_list << amenity.name
    end
    self.tag_list << self.name unless self.tag_list.empty?
  end
  def update_items
    items.delete_all
    selected_items = items_list.nil? ? [] : items_list.keys.collect{|id| Item.find(id)}
    selected_items.each {|item| self.items << item}  
  end
end
