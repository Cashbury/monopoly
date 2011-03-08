class Program < ActiveRecord::Base
	include ActiveModel::Validations
	has_many :accounts,:foreign_key=>'program_id'
	belongs_to :business
	belongs_to :program_type
	
	validates_presence_of :name,:type_id,:business_id
	validates_with DatesValidator, :start => :start_date, :end => :end_date
	validates_with PointsValidator, :initial => :initial_points, :max => :max_points

end