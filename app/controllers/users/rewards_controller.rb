class Users::RewardsController < Users::BaseController
	def claim
		begin
			reward=Reward.find(params[:id])
			if reward.program.nil?
				respond_with_error(ERRORS[:msg_not_related_to_program])
			elsif (account=user.accounts.where(:program_id=>reward.program.id).first).blank?
				respond_with_error(ERRORS[:msg_user_not_enrolled])
			else
				if reward.auto_unlock
					reward.is_claimed_by(current_user,account)
					respond_to do |format|
		      	format.xml { render :xml => reward_hash(reward,account,reward.program),:status=>200 }
		    	end
		    elsif account.points < reward.points 
		    	respond_with_error(ERRORS[:msg_not_enough_credit])
				else
					number_of_times=UserAction.where(:user_id=>current_user.id,:reward_id=>reward.id).count
					if number_of_times >=reward.claim
						respond_with_error(ERRORS[:msg_exceeds_claim_limit])
					else
						reward.is_claimed_by(current_user,account)
						respond_to do |format|
		      		format.xml { render :xml => reward_hash(reward,account,reward.program),:status=>200 }
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
  	:msg_not_related_to_program=>"Reward not associated to program",
  	:msg_user_not_enrolled     =>"User not enrolled with the reward's program",
  	:msg_not_enough_credit     =>"Not enough credit",
  	:msg_exceeds_claim_limit   =>"Reward reached max mumber of claims"
  }
  
  private
	def reward_hash(reward,account,program)
    r = {:redeem => {}}
		r[:redeem].merge!({:business_id      => program.business.id})
		r[:redeem].merge!({:program_id       => program.id})
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
