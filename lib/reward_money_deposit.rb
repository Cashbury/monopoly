class RewardMoneyDeposit < Struct.new(:account_id)

  def perform
    account = Account.where(:id => self.account_id).first
    account_holder = account.account_holder
    if account_holder.model_type == 'User'
      user = User.where(:id => account_holder.model_id).first
      accounts = Account.where(:account_holder_id => account_holder.id)
      spend_campaign = Campaign.where(:ctype => Campaign::CTYPE[:spend], 
                                      :id => accounts.map(&:campaign_id)).first
      reward = spend_campaign.rewards.first
      user_account= spend_campaign.user_account(user)
      if user_account.amount >= reward.needed_amount 
        reward.is_claimed_by(user, user_account, nil, nil, nil)
      end
    end    
  end

end
