class Users::RewardsController < Users::BaseController
  before_filter :find_business_and_engagments
  before_filter :places_under_business

  def index
    @rewards = @business.rewards
    respond_to do |format|
      format.xml { render :xml => @rewards }
    end
  end
	
	def claim
		#here should deduce from account points
	end
	
  private
  def find_business_and_engagments
    @business = Business.find(params[:business_id])
    @engagements = @business.engagements.stamps
  end

  def places_under_business
    @places ||= Place.where(:business_id => params[:business_id]) 
  end
end
