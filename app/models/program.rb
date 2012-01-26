# == Schema Information
# Schema version: 20110615133925
#
# Table name: programs
#
#  id              :integer(4)      not null, primary key
#  program_type_id :integer(4)
#  business_id     :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#  name            :string(255)
#  is_started      :boolean(1)
#

class Program < ActiveRecord::Base
  belongs_to :program_type
  belongs_to :business
  has_many :accounts
  has_many :campaigns,:dependent=>:destroy
  validates_presence_of :business_id, :program_type_id
  validates_uniqueness_of :program_type_id, :scope=>[:business_id]  
  
  scope :running_campaigns, where("? > campaigns.start_date && ? < campaigns.end_date", Date.today, Date.today)
  scope :money, lambda {
    pt_id = ProgramType["Money"].id
    where(:program_type_id => pt_id)
  }
  after_create :assign_money_accounts, :if => lambda { |m| m.is_money? }

  def program_type_name
    return self.program_type.name
  end

  def is_money?
    self.program_type == ProgramType["Money"]
  end

  protected
  def assign_money_accounts
    account_holder = business.account_holder || business.create_account_holder
    Account.transaction do
      Account.create! :business_id => business_id,
        :program_id                => id,
        :is_money                  => true,
        :amount                    => 0,
        :account_holder_id         => account_holder.id

      Account.create! :business_id => business_id,
        :program_id                => id,
        :is_reserve                => true,
        :amount                    => 0,
        :account_holder_id         => account_holder.id

      Account.create! :business_id => business_id,
        :program_id                => id,
        :is_cashbury               => true,
        :amount                    => 0,
        :account_holder_id         => account_holder.id
    end
  end
end
