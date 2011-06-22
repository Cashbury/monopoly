class OpenHour < ActiveRecord::Base
	belongs_to :place
	DAYS={
		"Sunday"=>0,
		"Monday"=>1,
		"Tuesday"=>2,
		"Wednesday"=>3,
		"Thursday"=>4,
		"Friday"=>5,
		"Saturday"=>6
	}
	
	DISPLAY_DAYS={
    0=>"Sunday",
    1=>"Monday",
    2=>"Tuesday",
    3=>"Wednesday",
    4=>"Thursday",
    5=>"Friday",
    6=>"Saturday"
  }
  validates_presence_of :day_no,:from,:to
	validates_uniqueness_of :place_id,:scope=>[:day_no,:from,:to]
  def self.format_time(datetime)
   #datetime.strftime("%I:%M %p").upcase
    return_hour = ""
    if datetime.hour >= 13 and datetime.hour <=23
      return_hour= "#{(datetime.hour-12).to_s}:#{sprintf('%02d',datetime.min)} PM"
    elsif datetime.hour ==12
      return_hour= "#{(datetime.hour).to_s}:#{sprintf('%02d',datetime.min)} PM"
    elsif datetime.hour ==0
      return_hour= "12:#{sprintf('%02d',datetime.min)} AM"
    else
      return_hour= "#{(datetime.hour).to_s}:#{sprintf('%02d',datetime.min)} AM"
    end
    return return_hour
  end
  def self.has_two_hour_for_same_day(place, day_num)
   open_hours = OpenHour.where(:place_id=>place.id,:day_no=>day_num)
   open_hours.size == 2
  end
  def self.has_two_hour_at_any_day(place)
    0.upto(6) do |day_num|
      open_hours = OpenHour.where(:place_id=>place.id,:day_no=>day_num)
      if open_hours.size == 2
        return true
      end
    end
    return false
  end
end
