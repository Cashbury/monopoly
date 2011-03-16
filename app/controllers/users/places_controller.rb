class Users::PlacesController < Users::BaseController
	after_filter :auto_enroll_user
	
  def index
    @places = Place.all
    respond_to do |format|
      format.xml { render :xml => @places }
    end
  end
  
  def show
    @places=[]
    unless params[:long].blank? and  params[:lat].blank?
			@places = Place.within(DISTANCE,:units=>:km,:origin=>[params[:lat].to_f,params[:long].to_f]).order('distance ASC')
	  else
	  	@places = Place.all
    end
    respond_to do |format|
      format.xml { render :xml => @places }
    end
  end
  
  private
  def auto_enroll_user
  	begin
			ids=@places.collect{|p| p.business_id}
			businesses=Business.where(:id=>ids)
			businesses.each do |business|
				business.programs.auto_enrolled_ones.each do |program|
					unless current_user.has_account_with_program?(program.id)
						Account.create!(:user_id=>current_user.id,:program_id=>program.id,:points=>program.initial_points)
					end
				end
			end
		rescue Exception=>e
			logger.error "Exception #{e.class}: #{e.message}"
		end
  end
  
  def user_not_engaged_with?(business_id)
  	current_user.user_actions.where(:business_id=>business_id).empty?
  end
  
end
