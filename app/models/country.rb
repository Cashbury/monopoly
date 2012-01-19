# == Schema Information
# Schema version: 20110615133925
#
# Table name: countries
#
#  id   :integer(4)      not null, primary key
#  name :string(255)
#  abbr :string(255)
#

class Country < ActiveRecord::Base
  # attr_accessible
  has_many :cities
  has_many :addresses
  has_one  :address_profile
  has_attached_file :currency_icon , :styles=>{
                                        :small=>"8x8",
                                        :medium=>"16x16",
                                        :large=>"32x32"
                                      }

  around_save :update_places_phones
                                      
  def flag_url
    "#{COUNTRIES_FLAGS_PATH}#{self.iso2.to_s.downcase}.png" if self.iso2.present?
  end

  def update_places_phones
    code = self.phone_country_code
    original_code = Country.where(:id => self.id).first.try(:phone_country_code)
    yield

    if code != original_code
      businesses = Business.where(:country_id => self.id)
      places = Place.where(:business_id => businesses.map(&:id))

      places.each do |place|
        phone_number = place.phone
        if phone_number
          phone_number.gsub!(/^#{Regexp.escape(original_code)}/, '')
          place.phone = phone_number
          place.save
        end
      end

      users = User.where(:home_town => self.id)

      users.each do |user|
        phone_number = user.telephone_number
        if phone_number
          phone_number.gsub!(/^#{Regexp.escape(original_code)}/, '')
          user.telephone_number = phone_number
          user.save
        end        
      end

    end
  end
  
end
