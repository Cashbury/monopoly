class Campaign < ActiveRecord::Base
	include ActiveModel::Validations
	has_many   :accounts,:foreign_key=>'campaign_id'
	has_many   :engagements,:foreign_key=>'campaign_id'
	has_many   :rewards,:foreign_key=>'campaign_id'
	
	belongs_to :program
	belongs_to :measurement_type
	
	validates_presence_of :name,:measurement_type_id,:program_id
	validates_format_of :start_date, :with => /\d{4}-\d{2}-\d{2}/, :message => "^Date must be in the following format: yyyy/mm/dd"
	validates_format_of :end_date, :with => /\d{4}-\d{2}-\d{2}/, :message => "^Date must be in the following format: yyyy/mm/dd"
	validates_numericality_of :initial_points
	validates_with DatesValidator, :start => :start_date, :end => :end_date,:unless=>Proc.new{|r| r.start_date.nil? || r.end_date.nil?}
	
	scope :running_campaigns, where("#{Date.today} > start_date && #{Date.today} < end_date")
	
	def has_auto_unlock_reward?
		!self.rewards.where(:auto_unlock=>true).empty?
	end
	
	def is_running?
	  date=Date.today
	  date > start_date && date < end_date 
	end
end