# == Schema Information
# Schema version: 20110615133925
#
# Table name: places
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  long            :decimal(15, 10)
#  lat             :decimal(15, 10)
#  business_id     :integer(4)
#  description     :text
#  created_at      :datetime
#  updated_at      :datetime
#  place_type_id   :integer(4)
#  is_user_defined :boolean(1)
#  address_id      :integer(4)
#  time_zone       :string(255)
#  user_id         :integer(4)
#  phone           :string(255)
#  is_primary      :boolean(1)
#

class Place < ActiveRecord::Base
  include Geokit::Geocoders
	acts_as_mappable  :lng_column_name => :long
	acts_as_taggable
  belongs_to :business
  belongs_to :place_type
  belongs_to :address
  has_many :item_places
  has_many :items , :through => :item_places
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
  accepts_nested_attributes_for :open_hours

  attr_accessible :name, :long, :lat, :description, :business_id, :time_zone,:tag_list,:place_images_attributes,:address_attributes , :items_attributes, :tmp_images_attributes,:phone,:business,:distance , :is_primary
  attr_accessor :items_list
  validates :name , :presence=>{:message=> "Branch name can not be blank"}
  validates :long, :lat , :presence=>{:message=>"Co-ordinates is can not be located"}
  validates :address, :presence=>{:message=>"Address is can not be determined"}

  validates :long,:lat , :numericality=>{:message=>"Not proper co-ordinate format" }
  validates_format_of       :phone, :with => /^(00|\+)[0-9]+$/, :message=>"Number should start with 00 | +",:allow_blank=>true

  validates_associated :address

  scope :with_address,joins(:address=>[:city,:country])
                      .select("places.id,places.name,places.long,places.lat,places.description,places.address_id,places.is_user_defined,places.business_id,places.time_zone,places.phone,
                               addresses.zipcode,addresses.neighborhood,addresses.street_address as address1,
                               countries.name as country")
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
  def add_item(item_params)
    self.items.build(item_params)
  end


  def add_open_hours(open_hours_params)
    self.open_hours.delete_all
    OpenHour::DAYS.each_with_index do |(key,value),index|
      i = index.to_s
      if !open_hours_params.nil? && open_hours_params[i].present?
        add_one_open_hour_to_place(open_hours_params[i],"from","to","closed")
        if open_hours_params[i]["from2"].present? and open_hours_params[i]["to2"].present?
          add_one_open_hour_to_place(open_hours_params[i],"from2","to2","closed")
        end
      end # End of ( if open_hours_params[i].present?)
    end
  end
  def add_one_open_hour_to_place(open_hours_params,from,to,closed)
    open_hour = OpenHour.new
    if !open_hours_params.nil? && open_hours_params[closed].nil?
      open_hour.from = create_date_time(open_hours_params[from])
      open_hour.to   = create_date_time(open_hours_params[to])
      open_hour.day_no = open_hours_params[:day_no]
      open_hour.place_id = open_hours_params[:place_id]
      self.open_hours << open_hour
    end
  end


  def self.save_place_by_geolocation(location,user)
    address = Geokit::Geocoders::GoogleGeocoder.geocode(location[:location])

    country = Country.find_or_create_by_name_and_abbr(:name=>address.country, :abbr=>address.country_code)
    city = City.find_or_create_by_name_and_country_id(:name=>address.city, :country_id=>country.id)

    a = Address.new
    a.country_id = country.id
    a.city_id = city.id
    a.street_address=location[:street_address]
    a.cross_street = location[:cross_street]
    a.neighborhood = location[:neighborhood]
    logger.error "Invalid Address #{a.inspect}" unless a.save!

    business = Business.find_or_create_by_name(location[:business_name])
    business.billing_address_id = a.id
    business.mailing_address_id = a.id
    business.brand_id = user.brands.first.id
    business.save!

    place = Place.new
    place.name = location[:name]
    place.phone = location[:phone]
    place.user_id = user.id
    place.lat= location[:lat]
    place.long= location[:long]
    place.is_primary= location[:is_primary] unless location[:is_primary].blank?
    place.address_id = a.id
    place.business_id = business.id
    place
  end


  def get_hour(day_num, hour_type, second_record_for_same_day)
    if second_record_for_same_day
     open_hour = OpenHour.where(:place_id => self.id , :day_no => day_num)[1]
    else
     open_hour = OpenHour.where(:place_id => self.id , :day_no => day_num)[0]
    end
    return_hour = "12:00 AM"
    if open_hour
      datetime    = open_hour.from if hour_type == :from
      datetime    =  open_hour.to if hour_type == :to
      return_hour = OpenHour.format_time(datetime)
    end
    return return_hour
  end
  def is_closed(day_num)
    open_hour =OpenHour.where(:place_id => self.id , :day_no => day_num).first
    if open_hour
      return false
    else
      return true
    end
  end

  private
  def add_amenities_name_and_place_name_to_place_tag_lists
    self.amenities.each do |amenity|
      self.tag_list << amenity.name
    end
    unless self.business.try(:categories).nil?
      self.business.try(:categories).each do |cat|
        self.tag_list << cat.name
        while (parent=cat.parent) !=nil
          self.tag_list << parent.name unless self.tag_list.include?(parent.name)
          cat=parent
        end
      end
    end
    self.tag_list << self.name
  end
  def update_items
    selected_items = items_list.nil? ? [] : items_list.keys.collect{|id| Item.find(id)}
    selected_items.each {|item|
      unless self.items.include?(item)
        self.items << item
      end
    }
  end
  def parse_date(hour_text)
    tmp = hour_text.split(':')
    hour = tmp[0].to_i
    tmp2 = tmp[1].split(' ')
    min = tmp2[0].to_i
    am_or_pm = tmp2[1]
    hour +=12 if am_or_pm == "PM" && hour >= 1 && hour <=11
    hour  =0  if am_or_pm == "AM" && hour ==12
    # if hour >= 1 and hour <=11 and am_or_pm.upcase == "PM"
    #   hour +=12
    # elsif am_or_pm.upcase=="AM" and hour=12
    #   hour  =0
    # end
    [hour,min]
  end
  def create_date_time(hour_txt)
    hour, min = parse_date(hour_txt)
    datetime = DateTime.civil(DateTime.now.year ,DateTime.now.month, DateTime.now.day, hour.to_i , min.to_i)
  end

end
