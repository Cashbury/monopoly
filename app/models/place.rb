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
  def add_item(item_params)
    self.items.build(item_params)
  end
  def add_open_hours(open_hours_params) 
    self.open_hours.delete_all
    OpenHour::DAYS.each_with_index do |(key,value),index|
       i = index.to_s
       if open_hours_params[i].present?
           add_one_open_hour_to_place(open_hours_params[i],"from","to","closed")
           if open_hours_params[i]["from2"].present? and open_hours_params[i]["to2"].present?
             add_one_open_hour_to_place(open_hours_params[i],"from2","to2","closed2")
           end
       end
     end # End of ( if open_hours_params[i].present?)  
  end
  def add_one_open_hour_to_place(open_hours_params,from,to,closed)
    open_hour = OpenHour.new
    if open_hours_params[closed].blank?
        open_hour.from = create_date_time(open_hours_params[from])
        open_hour.to   = create_date_time(open_hours_params[to])
        open_hour.day_no = open_hours_params[:day_no] 
        open_hour.place_id = open_hours_params[:place_id]
        self.open_hours << open_hour
    end
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
     open_hour = OpenHour.where(:place_id => self.id , :day_no => day_num).first
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
    self.business.categories.each do |cat|
      self.tag_list << cat.name
      while (parent=cat.parent) !=nil
        self.tag_list << parent.name unless self.tag_list.include?(parent.name)
        cat=parent 
      end
    end
    self.tag_list << self.name unless self.tag_list.empty?
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
    min = tmp2[0]
    am_or_pm = tmp2[1]
    hour +=12 if am_or_pm == "PM"
    [hour,min]
  end
  def create_date_time(hour_txt)
    hour, min = parse_date(hour_txt)
    datetime = DateTime.civil(DateTime.now.year ,DateTime.now.month, DateTime.now.day, hour.to_i , min.to_i)
  end
  
end
