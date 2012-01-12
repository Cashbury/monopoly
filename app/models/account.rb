# == Schema Information
# Schema version: 20110615133925
#
# Table name: accounts
#
#  id                  :integer(4)      not null, primary key
#  created_at          :datetime
#  updated_at          :datetime
#  account_holder_id   :integer(4)
#  campaign_id         :integer(4)
#  measurement_type_id :integer(4)
#  amount              :decimal(20, 3)
#  is_money            :boolean(1)
#  is_external         :boolean(1)
#  payment_gateway_id  :integer(4)
#  program_id          :integer(4)
#  business_id         :integer(4)
#

class Account < ActiveRecord::Base
  belongs_to :account_holder
  belongs_to :campaign
  belongs_to :measurement_type
  belongs_to :payment_gateway
  belongs_to :business
  belongs_to :program

  has_one :account_option
  
  has_many :transactions, :foreign_key=>"from_account"
  
  # Let's not require this just yet -- Arron.
  #validates_uniqueness_of :account_holder_id, :scope => [:program_id, :campaign_id]
  # Let's not require this just yet -- Arron.
  #validates_presence_of :measurement_type_id
  validates_numericality_of :amount
  
  
  cattr_reader :per_page
  @@per_page = 20

  delegate :campaign_name, :to => :campaign, :allow_nil => true
  delegate :program_type_name, :to => :program, :allow_nil => true
  
  def is_owned_by_consumer?
    account_holder.model.is_a?(User) && account_holder.model.role?(:consumer)
  end

  def load(amount, initiated_by = nil)
    ensure_consumer_account!
    business.reserve_account.move_money!(amount, self, Action["Load"], initiated_by)
  end

  def spend(amount, initiated_by = nil)
    ensure_consumer_account!
    move_money!(amount, business.reserve_account, Action["Spend"], initiated_by)
  end

  def cashout(initiated_by = nil)
    ensure_consumer_account!
    move_money!(amount, business.reserve_account, Action["Cashout"], initiated_by)
  end
  

  def withdraw_from_account(amount,user_id)
    if associated_to_campaign?
      business_account=self.campaign.business_account
    elsif associated_to_business?
      business=Business.find(self.business_id) 
      business_accholder=AccountHolder.find_or_create_by_model_id_and_model_type(:model_id=>business.id,:model_type=>"Business")     
      business_account=Account.find_or_create_by_account_holder_id(business_accholder.id)
    end
    user_account=self
    date=Date.today.to_s
    Account.transaction do
      action=Action.where(:name=>Action::CURRENT_ACTIONS[:withdraw]).first
      transaction_type =action.transaction_type
      after_fees_amount=transaction_type.fee_amount.nil? ? amount : amount-transaction_type.fee_amount
      after_fees_amount=transaction_type.fee_percentage.nil? ? after_fees_amount : (after_fees_amount-(after_fees_amount * transaction_type.fee_percentage/100))

      business_account_before_balance=business_account.amount
      business_account.increment!(:amount,after_fees_amount)
      business_account.increment!(:cumulative_amount,after_fees_amount)

      user_account_before_balance=user_account.amount
      user_account.decrement!(:amount,after_fees_amount)
      
      #save the transaction record
      transaction=Transaction.create!(:from_account=>user_account.id,
                                      :to_account=>business_account.id,
                                      :before_fees_amount=>amount,
                                      :payment_gateway=>user_account.payment_gateway,
                                      :is_money=>!self.associated_to_campaign?,
                                      :from_account_balance_before=>user_account_before_balance,
                                      :from_account_balance_after=>user_account.amount,
                                      :to_account_balance_before=>business_account_before_balance,
                                      :to_account_balance_after=>business_account.amount,
                                      :currency=>nil,
                                      :note=>"Account transfer (withdraw) from user account",
                                      :transaction_type_id=>action.transaction_type_id,
                                      :after_fees_amount=>after_fees_amount,
                                      :transaction_fees=>transaction_type.fee_amount)
      
      log_group=LogGroup.create!(:created_on=>date)
      Log.create!(:user_id        =>user_id,
                  :action_id      =>action.id,
                  :log_group_id   =>log_group.id,
                  :business_id    =>self.business_id,
                  :transaction_id =>transaction.id,
                  :frequency      =>1,
                  :created_on     =>date)                                      
       self                               
    end
  end  
  
  def deposit_to_account(amount,user_id)
    if associated_to_campaign?
      business_account=self.campaign.business_account
    elsif associated_to_business?
      business=Business.find(self.business_id)      
      business_accholder=AccountHolder.find_or_create_by_model_id_and_model_type(:model_id=>business.id,:model_type=>"Business")     
      business_account=Account.find_or_create_by_account_holder_id(business_accholder.id)
    end
    user_account=self
    date=Date.today.to_s
    Account.transaction do
      action=Action.where(:name=>Action::CURRENT_ACTIONS[:deposit]).first
      transaction_type =action.transaction_type
      after_fees_amount=transaction_type.fee_amount.nil? ? amount : amount-transaction_type.fee_amount
      after_fees_amount=transaction_type.fee_percentage.nil? ? after_fees_amount : (after_fees_amount-(after_fees_amount * transaction_type.fee_percentage/100))

      business_account_before_balance=business_account.amount
      business_account.decrement!(:amount,after_fees_amount)
      

      user_account_before_balance=user_account.amount
      user_account.increment!(:amount,after_fees_amount)
      user_account.increment!(:cumulative_amount,after_fees_amount)
      
      #save the transaction record
      transaction=Transaction.create!(:from_account=>business_account.id,
                                      :to_account=>user_account.id,
                                      :before_fees_amount=>amount,
                                      :payment_gateway=>user_account.payment_gateway,
                                      :is_money=>!self.associated_to_campaign?,
                                      :from_account_balance_before=>business_account_before_balance,
                                      :from_account_balance_after=>business_account.amount,
                                      :to_account_balance_before=>user_account_before_balance,
                                      :to_account_balance_after=>user_account.amount,
                                      :currency=>nil,
                                      :note=>"Account transfer (deposit) to user account",
                                      :transaction_type_id=>action.transaction_type_id,
                                      :after_fees_amount=>after_fees_amount,
                                      :transaction_fees=>transaction_type.fee_amount)
      log_group=LogGroup.create!(:created_on=>date)
      Log.create!(:user_id        =>user_id,
                  :action_id      =>action.id,
                  :log_group_id   =>log_group.id,
                  :business_id    =>self.business_id,
                  :transaction_id =>transaction.id,      
                  :frequency      =>1,
                  :created_on     =>date)                                      
       self                               
    end
  end  
  
  def associated_to_campaign?
    self.campaign_id.present?
  end 
  
  def associated_to_business?
    self.business_id.present?
  end 
  
  def associated_to_program?
    self.program_id.present?
  end  
  
  def self.listing_user_enrollments(user_id,program_type_id)
    joins([:account_holder, :campaign=>[:program=>[:program_type,:business]]])
    .joins("LEFT OUTER JOIN countries ON businesses.country_id=countries.id")
    .where("campaigns.ctype=#{Campaign::CTYPE[:spend]} and programs.program_type_id=#{program_type_id} and account_holders.model_id=#{user_id} and account_holders.model_type='User'")
    .select("accounts.status,program_types.id as pt_id,businesses.name as b_name, countries.name as c_name, program_types.name as pt_name, accounts.amount as current_amount, accounts.cumulative_amount, businesses.id as biz_id, programs.id as p_id, account_holders.model_id as uid ")
    .group("businesses.id")
  end

  protected
  def ensure_consumer_account!
    unless is_owned_by_consumer?
      raise "Can only cash out a consumer account! (is actually: #{account_holder.model.class.name}: #{account_holder.model.roles.collect(&:name)})"
    end
  end

  # Moves money from one account to another.
  def move_money!(move_amount, to_account, action, initiated_by = nil)
    self.amount -= move_amount
    to_account.amount += move_amount

    transaction = Transaction.new(:from_account => id,
      :to_account => to_account.id,
      :before_fees_amount => move_amount,
      :payment_gateway => payment_gateway,
      :is_money => true,
      :from_account_balance_before => amount_was,
      :from_account_balance_after => amount,
      :to_account_balance_before=> to_account.amount_was,
      :to_account_balance_after => to_account.amount,
      :currency => nil,
      :note => "Account #{action.name}",
      :transaction_type_id => action.transaction_type_id,
      :after_fees_amount => move_amount,
      :transaction_fees => action.transaction_type.fee_amount)

    Account.transaction do
      save!
      to_account.save!
      transaction.save!

      Log.create!(:user_id => initiated_by.try(:id) || account_holder_id,
        :action_id         => action.id,
        :business_id       => business_id,
        :transaction_id    => transaction.id,
        :frequency         => 1,
        :created_on        => DateTime.now)
    end
  end

end
