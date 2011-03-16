class Program < ActiveRecord::Base
	include ActiveModel::Validations
	has_many   :accounts,:foreign_key=>'program_id'
	has_many   :engagements,:foreign_key=>'program_id'
	belongs_to :business
	belongs_to :program_type
	has_many   :rewards
	
	validates_presence_of :name,:program_type_id,:business_id
	validates_format_of :start_date, :with => /\d{4}-\d{2}-\d{2}/, :message => "^Date must be in the following format: yyyy/mm/dd"
	validates_format_of :end_date, :with => /\d{4}-\d{2}-\d{2}/, :message => "^Date must be in the following format: yyyy/mm/dd"
	validates_numericality_of :initial_points,:max_points
	validates_with DatesValidator, :start => :start_date, :end => :end_date,:unless=>Proc.new{|r| r.start_date.nil? || r.end_date.nil?}
	validates_with PointsValidator, :initial => :initial_points, :max => :max_points
	
	scope :auto_enrolled_ones , where(:auto_enroll=>true)
	
	def has_auto_unlock_reward?
		!self.rewards.where(:auto_unlock=>true).empty?
	end
end