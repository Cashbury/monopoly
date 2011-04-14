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
	validates_presence_of :day_no,:from,:to
	validates_uniqueness_of :place_id,:scope=>[:day_no,:from,:to]
end
