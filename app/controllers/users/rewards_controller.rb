class Users::RewardsController < Users::BaseController
	def claim
		begin
			reward=Reward.find(params[:id])
			if reward.campaign.nil?
				respond_with_error(ERRORS[:msg_not_related_to_campaign])
			elsif (account=current_user.account_holder.accounts.where(:campaign_id=>reward.campaign.id).first).blank?
				respond_with_error(ERRORS[:msg_user_not_enrolled])
			else
		    if account.amount < reward.needed_amount 
		    	respond_with_error(ERRORS[:msg_not_enough_credit])
				else
					number_of_times=Log.redeems_logs.where(:user_id=>current_user.id,:reward_id=>reward.id).count
					if !reward.claim.nil? && number_of_times >=reward.claim
						respond_with_error(ERRORS[:msg_exceeds_claim_limit])
					else
						reward.is_claimed_by(current_user,account,params[:place_id],params[:lat],params[:lng])
						respond_to do |format|
		      		format.xml { render :xml => reward_hash(reward,account,reward.campaign),:status=>200 }
		    		end
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
  	:msg_not_enough_credit      =>"Not enough credit",
  	:msg_exceeds_claim_limit    =>"Reward reached max mumber of claims"
  }
  
  private
	def reward_hash(reward,account,campaign)
    r = {:redeem => {}}
		r[:redeem].merge!({:business_id      => program.business.id})
		r[:redeem].merge!({:campaign_id      => campaign.id})
		r[:redeem].merge!({:reward_id        => reward.id})
		r[:redeem].merge!({:account_points   => account.points})
    r
  end
  
  def respond_with_error(error)
		respond_to do |format|
			format.xml { render :text => error,:status=>500 }
		end
  end
end
