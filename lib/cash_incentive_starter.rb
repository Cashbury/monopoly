class CashIncentiveStarter < Struct.new(:campaign_id)

  def perform
    campaign = Campaign.where(:id => self.campaign_id).first
    reward = campaign.rewards.first
    business = campaign.program.business
    users = User.all
    users.each do |user|
      if user.consumer?
        user.cash_incentive(business, reward.money_amount, self.campaign_id) 
      end
    end
  end

end
