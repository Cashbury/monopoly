class Businesses::EngagementTypesController < ApplicationController
 before_filter :prepare_business
 
 
 def index
    @engagement_types = EngagementType.where(:business_id => @business.id)
  end
  
  def show
    @engagement_type = EngagementType.find(params[:id])
  end
 
 def new
  @engagement_type = EngagementType.new
 end
 
 def create
    @engagement_type = EngagementType.new(params[:engagement_type])
    if @engagement_type.save
      flash[:notice] = "Successfully created Engegement Type."
      redirect_to business_engagement_type_url(@business,@engagement_type)
    else
      render :action => 'new'
    end
 end
 
 def edit
    @engagement_type = EngagementType.find(params[:id])
  end
  
  def update
    @engagement_type = EngagementType.find(params[:id])
    if @engagement_type.update_attributes(params[:engagement_type])
      flash[:notice] = "Successfully updated Engagement Type."
      redirect_to  business_engagement_type_url(@business,@engagement_type)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @engagement_type = EngagementType.find(params[:id])
    @engagement_type.destroy
    flash[:notice] = "Successfully destroyed Engagement Type."
    redirect_to business_engagement_types_url(@business)
  end
  
 
 private 
 def prepare_business
   @business = Business.find(params[:business_id])
 end
 
end