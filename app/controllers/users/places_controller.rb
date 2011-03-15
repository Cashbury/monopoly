class Users::PlacesController < Users::BaseController
	
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
  
end
