class Users::RewardsController < Users::BaseController
	def claim
		begin
			reward=Reward.find(params[:id])
			if reward.campaign.nil?
				respond_with_error(ERRORS[:msg_not_related_to_campaign])
			elsif (user_account=reward.campaign.user_account(current_user)).blank?
				respond_with_error(ERRORS[:msg_user_not_enrolled])
			else
		    if user_account.amount < reward.needed_amount 
		    	respond_with_error(ERRORS[:msg_not_enough_credit])
				else
          reward.is_claimed_by(current_user,user_account,params[:place_id],params[:lat],params[:lng])
          respond_to do |format|
            format.xml { render :xml => reward_hash(reward,user_account,reward.campaign),:status=>200 }
          end
				end
			end
    rescue Exception => e
      logger.error "Exception #{e.class}: #{e.message}"
		 	respond_with_error(e.message)
		 end
	end
	
	ERRORS={
  	:msg_not_related_to_campaign=>"Reward not associated to campaign",
  	:msg_user_not_enrolled      =>"User not enrolled with the reward's campaign",
  	:msg_not_enough_credit      =>"Not enough credit"
  }
  
  private
	def reward_hash(reward,account,campaign)
    r = {:redeem => {}}
		r[:redeem].merge!({:business_id      => campaign.program.business.id})
		r[:redeem].merge!({:campaign_id      => campaign.id})
		r[:redeem].merge!({:reward_id        => reward.id})
		r[:redeem].merge!({:account_amount   => account.amount})
    r
  end
end
