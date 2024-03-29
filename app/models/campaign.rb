# == Schema Information
# Schema version: 20110615133925
#
# Table name: campaigns
#
#  id                  :integer(4)      not null, primary key
#  name                :string(255)     not null
#  start_date          :date
#  end_date            :date
#  initial_amount      :decimal(20, 3)  default(0.0)
#  created_at          :datetime
#  updated_at          :datetime
#  program_id          :integer(4)
#  measurement_type_id :integer(4)
#  state               :string(255)
#  initial_biz_amount  :decimal(20, 3)
#  has_target          :boolean(1)
#

class Campaign < ActiveRecord::Base
	include ActiveModel::Validations
	has_many   :accounts
	has_many   :engagements, :dependent => :destroy
	has_many   :rewards, :dependent => :destroy
  has_and_belongs_to_many :places
  has_and_belongs_to_many :targets
	belongs_to :program
	belongs_to :measurement_type

	validates_presence_of :name, :measurement_type_id, :program_id, :start_date
	validates_format_of :start_date, :with => /\d{4}-\d{2}-\d{2}/, :message => "^Date must be in the following format: yyyy-mm-dd"
	validates_format_of :end_date, :with => /\d{4}-\d{2}-\d{2}/, :message => "^Date must be in the following format: yyyy-mm-dd",:allow_nil=>true
	validates_numericality_of :initial_amount
	validates_with DatesValidator, :start => :start_date, :end => :end_date,:unless=>Proc.new{|r| r.start_date.nil? || r.end_date.nil?}
  validate :check_if_campaign_exist
  
	after_create :create_campaign_business_account
	before_create :init
  before_create :ensure_business_money_program, :if => Proc.new {|c| c.cash_incentive? || c.spend_campaign? }
	after_save :update_places
	
	scope :running_campaigns, where("? >= start_date && ? < end_date", Date.today, Date.today)
	attr_accessor :places_list,:item_name
	accepts_nested_attributes_for :engagements
	accepts_nested_attributes_for :rewards,:allow_destroy => true

	CTYPE = {
	  :spend => 1,
	  :share => 2,
	  :buy => 3,
	  :visit => 4,
	  :cash_incentive => 5
	}
	
	def check_if_campaign_exist
    if self.new_record? and self.ctype == Campaign::CTYPE[:spend] and Campaign.joins(:program => :business).where("ctype=#{Campaign::CTYPE[:spend]} and ((end_date IS NOT null AND '#{Date.today}' BETWEEN start_date AND end_date) || '#{Date.today}' >= start_date) and businesses.id=#{self.program.business.id}").any? 
      errors.add_to_base "There is already a spend based campaign running at the business, You could edit it or remove from the system"
    end
  end

  def init
    self.initial_biz_amount ||= 10000
  end
  
	def spend_campaign?
	  self.ctype == CTYPE[:spend]
  end
  
  def buy_campaign?
    self.ctype == CTYPE[:buy]
  end

  def cash_incentive?
    self.ctype == CTYPE[:cash_incentive]
  end

  
	def is_running?
	  date = Date.today
	  date >= start_date && date < end_date
	end

	def business_account
    self.accounts.joins(:account_holder).where("account_holders.model_id=#{self.program.business.id} and account_holders.model_type='Business'").first
  end

  def user_account(user)
    self.accounts.joins(:account_holder).where("account_holders.model_id=#{user.id} and account_holders.model_type='User'").first
  end

	private
	def create_campaign_business_account 
    unless self.cash_incentive? # NO marketing account for this type of campaign
      account_holder = AccountHolder.find_or_create_by_model_id_and_model_type(:model_id => self.program.business.id,:model_type => self.program.business.class.to_s)
      account = Account.find_or_create_by_campaign_id_and_account_holder_id(:campaign_id => self.id,:amount => self.initial_biz_amount,:measurement_type => self.measurement_type,:account_holder_id => account_holder.id)
    end
  end

  def ensure_business_money_program
    pt = ProgramType.find_or_create_by_name(:name => ProgramType::AS[:money] )
    Program.find_or_create_by_business_id_and_program_type_id(:business_id => self.program.business.id,:program_type_id => pt.id)
  end
  
  def update_places
    places.delete_all
    selected_places = places_list.nil? ? [] : places_list.keys.collect{|id| Place.find(id)}
    selected_places.each {|place| self.places << place}
  end

  def update_engagement
    engagment.delete({:engagement_type_id=>4})
  end

end
