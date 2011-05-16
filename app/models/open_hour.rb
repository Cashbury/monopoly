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

end