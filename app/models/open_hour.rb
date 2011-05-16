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
	#validates_uniqueness_of :place_id,:scope=>[:day_no,:from,:to]
 def format_time(datetime)
   return_hour = ""
   if datetime.hour >= 13 and datetime.hour <=23
      return_hour= "#{(datetime.hour-12).to_s}:#{sprintf('%02d',datetime.min)} PM"
   else
      return_hour= "#{(datetime.hour).to_s}:#{sprintf('%02d',datetime.min)} AM"
   end
   return return_hour
 end
 def format_minute
   
 end
end