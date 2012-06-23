# == Schema Information
# Schema version: 20110615133925
#
# Table name: transactions
#
#  id                          :integer(4)      not null, primary key
#  from_account                :integer(4)
#  to_account                  :integer(4)
#  before_fees_amount          :decimal(20, 3)
#  payment_gateway             :string(255)
#  is_money                    :boolean(1)
#  created_at                  :datetime
#  updated_at                  :datetime
#  from_account_balance_before :decimal(20, 3)
#  from_account_balance_after  :decimal(20, 3)
#  to_account_balance_before   :decimal(20, 3)
#  to_account_balance_after    :decimal(20, 3)
#  currency                    :string(255)
#  note                        :text
#  transaction_type_id         :integer(4)
#  after_fees_amount           :decimal(20, 3)
#  transaction_fees            :decimal(20, 3)
#

class Transaction < ActiveRecord::Base
  belongs_to :account
  belongs_to :transaction_type
  belongs_to :payment_gateway
  belongs_to :transaction_group
  belongs_to :action

  has_many :receipts
  has_many :logs
	validates_presence_of :from_account, :to_account,:transaction_type_id, 
	                      :from_account_balance_before,:from_account_balance_after, 
	                      :to_account_balance_before,:to_account_balance_after

  delegate :name, :fee_amount, :fee_percentage, :to => :transaction_type
  delegate :name, to: :action, allow_nil: true, prefix: true

  module States
    VOID = "voided"
  end

  def in_state?(*states)
    states.detect { |s| s.to_s == self.state }.present?
  end

  def void!(voiding_user)
    Transaction.transaction do
      self.state = Transaction::States::VOID
      self.save!

      from_account = Account.find self.from_account
      to_account = Account.find self.to_account
      refundable = self.before_fees_amount

      from_account.amount += refundable
      to_account.amount -= refundable

      from_account.save!
      to_account.save!

      Log.create! :user_id => voiding_user.id,
        :transaction_id => self.id,
        :frequency => 1,
        :action_id => Action["Void"],
        :business => voiding_user.business
    end
  end

  # Options:
  #------------------
  # from_account ? 
  # to_account?
  # action ?
  # engagement ?
  # campaign ?
  # lat & Lng ?
  # reward
  # qr_code

  def self.fire(options)
    date = Date.today.to_s
    options[:freq] = options[:freq] || 1
    action = Action.where(:name => Action::CURRENT_ACTIONS[options[:action]]).first
    transaction_type = action.transaction_type
    after_fees_amount = transaction_type.fee_amount.nil? || transaction_type.fee_amount.zero? ? options[:amount] : options[:amount] - transaction_type.fee_amount
    after_fees_amount = transaction_type.fee_percentage.nil? || transaction_type.fee_percentage.zero? ? after_fees_amount : after_fees_amount - (after_fees_amount * transaction_type.fee_percentage/100)
    after_fees_amount = after_fees_amount * options[:freq]
   
    from_account_before_balance = options[:from_account].amount
    options[:from_account].decrement!(:amount, options[:amount] * options[:freq] )
    to_account_before_balance = options[:to_account].amount
    options[:to_account].increment!(:amount, after_fees_amount)
    options[:to_account].increment!(:cumulative_amount, after_fees_amount)
          
    #save the transaction record
    t = create!(:from_account => options[:from_account].id,
                :to_account => options[:to_account].id,
                :before_fees_amount => options[:amount] * options[:freq],
                :payment_gateway => options[:to_account].payment_gateway,
                :is_money => false,
                :from_account_balance_before => from_account_before_balance,
                :from_account_balance_after => options[:from_account].amount,
                :to_account_balance_before => to_account_before_balance,
                :to_account_balance_after => options[:to_account].amount,
                :currency => nil,
                :note => options[:note],
                :transaction_type_id => action.transaction_type_id,
                :after_fees_amount => after_fees_amount,
                :transaction_fees => transaction_type.fee_amount)

    #save this engagement action to logs
    log_group = LogGroup.create!(:created_on => date) if log_group.nil?
    business_id = options[:campaign].program.business.id
    if options[:place_id].blank?
      unless options[:lat].blank? || options[:lng].blank?
        place_id = Place.where(:business_id => business_id).closest(:origin => [options[:lat].to_f,options[:lng].to_f]).first.id
      end
    end
    Log.create!(:user_id        => options[:user].id,
                :action_id      => action.id,
                :log_group_id   => log_group.id,
                :engagement_id  => options[:associatable].try(:id),
                :reward_id      => options[:reward].try(:id),
                :qr_code_id     => options[:qr_code].try(:id),
                :campaign_id    => options[:campaign].id,
                :business_id    => business_id,
                :transaction_id => t.id,
                :place_id       => options[:place_id],
                :gained_amount  => after_fees_amount,
                :amount_type    => options[:to_account].measurement_type,
                :frequency      => options[:freq],
                :lat            => options[:lat],
                :lng            => options[:lng],
                :created_on     => date,
                :issued_by      => options[:issued_by])
  end
end
