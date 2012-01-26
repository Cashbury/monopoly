class CashIncentive < Struct.new(:user_id, :campaign_id)

  def perform
    user = User.where(:id => self.user_id).first
    campaign = Campaign.where(:id => self.campaign_id).first
    reward = campaign.rewards.first
    business = campaign.program.business
    if user.consumer?
      user.cash_incentive(business, reward.money_amount, self.campaign_id) 
    end
  end

end
