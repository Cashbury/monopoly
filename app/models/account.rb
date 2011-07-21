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
  
  has_many :transactions, :foreign_key=>"from_account"
  
  validates_uniqueness_of :account_holder_id, :scope => :campaign_id
  validates_presence_of :measurement_type_id
  validates_numericality_of :amount
  
  
  cattr_reader :per_page
  @@per_page = 20
  
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
                  :engagement_id  =>nil,
                  :qr_code_id     =>nil,
                  :campaign_id    =>nil,
                  :business_id    =>self.business_id,
                  :transaction_id =>transaction.id,
                  :place_id       =>nil,
                  :gained_amount  =>nil,
                  :amount_type    =>nil,
                  :frequency      =>1,
                  :lat            =>nil,
                  :lng            =>nil,
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
                  :engagement_id  =>nil,
                  :qr_code_id     =>nil,
                  :campaign_id    =>nil,
                  :business_id    =>self.business_id,
                  :transaction_id =>transaction.id,
                  :place_id       =>nil,
                  :gained_amount  =>nil,
                  :amount_type    =>nil,
                  :frequency      =>1,
                  :lat            =>nil,
                  :lng            =>nil,
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
end
