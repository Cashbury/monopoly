class Users::RewardsController < Users::BaseController
	def claim
		begin
			current_user=User.find_by_id(params[:uid]) unless params[:uid].blank?
			reward=Reward.find(params[:id])
			if reward.program.nil?
				respond_to do |format|
					format.xml { render :text => "Reward not associated to program",:status=>500 }
				end
			else
				if reward.auto_unlock
					account=reward.is_claimed_by(current_user)
					respond_to do |format|
		      	format.xml { render :xml => reward_hash(reward,account,reward.program),:status=>200 }
		    	end
				else
					number_of_times=UserAction.where(:user_id=>current_user.id,:reward_id=>reward.id).count
					if number_of_times >=reward.claim
						respond_to do |format|
		      		format.xml { render :text => "Reward reached max mumber of claims",:status=>500 }
		    		end
					else
						account=reward.is_claimed_by(current_user)
						respond_to do |format|
		      		format.xml { render :xml => reward_hash(reward,account,reward.program),:status=>200 }
		    		end
					end
				end
			end
		rescue Exception => e
			logger.error "Exception #{e.class}: #{e.message}"
			respond_to do |format|
				format.xml { render :text => e.message,:status=>500 }
			end
		end
	end
	
  private
	def reward_hash(reward,account,program)
    r = {:redeem => {}}
		r[:redeem].merge!({:business_id      => program.business.id})
		r[:redeem].merge!({:program_id       => program.id})
		r[:redeem].merge!({:reward_id        => reward.id})
		r[:redeem].merge!({:account_points   => account.points})
    r
  end
  
end
