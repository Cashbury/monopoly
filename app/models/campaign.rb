class Campaign < ActiveRecord::Base
	include ActiveModel::Validations
	has_many   :accounts
	has_many   :engagements, :dependent => :destroy
	has_many   :rewards, :dependent => :destroy
  has_and_belongs_to_many :places
  has_and_belongs_to_many :targets
	belongs_to :program
	belongs_to :measurement_type
	
	validates_presence_of :name,:measurement_type_id,:program_id,:start_date
	validates_format_of :start_date, :with => /\d{4}-\d{2}-\d{2}/, :message => "^Date must be in the following format: yyyy/mm/dd"
	validates_format_of :end_date, :with => /\d{4}-\d{2}-\d{2}/, :message => "^Date must be in the following format: yyyy/mm/dd",:allow_nil=>true
	validates_numericality_of :initial_amount
	validates_with DatesValidator, :start => :start_date, :end => :end_date,:unless=>Proc.new{|r| r.start_date.nil? || r.end_date.nil?}
	
	after_create :create_campaign_business_account
	after_initialize :init
	after_save :update_places
	scope :running_campaigns, where("#{Date.today} > start_date && #{Date.today} < end_date")
	attr_accessor   :places_list,:item_name
	accepts_nested_attributes_for :engagements
	accepts_nested_attributes_for :rewards
  def init
    self.initial_biz_amount ||= 10000 
  end
	
	def is_running?
	  date=Date.today
	  date > start_date && date < end_date 
	end
	
	def business_account
    self.accounts.joins(:account_holder).where("account_holders.model_id=#{self.program.business.id} and account_holders.model_type='Business'").first
  end
  
  def user_account(user)
    self.accounts.joins(:account_holder).where("account_holders.model_id=#{user.id} and account_holders.model_type='User'").first
  end
  
	private
	def create_campaign_business_account
	  account_holder  = AccountHolder.where(:model_id=>self.program.business.id,:model_type=>self.program.business.class.to_s).first 
	  unless account_holder
	    account_holder  = AccountHolder.create!(:model_id=>self.program.business.id,:model_type=>self.program.business.class.to_s) 
	  end
	  account = Account.create!(:campaign_id=>self.id,:amount=>self.initial_biz_amount,:measurement_type=>self.measurement_type,:account_holder => account_holder)
  end
  def update_places
    places.delete_all
    selected_places = places_list.nil? ? [] : places_list.keys.collect{|id| Place.find(id)}
    selected_places.each {|place| self.places << place}
  end
  
end