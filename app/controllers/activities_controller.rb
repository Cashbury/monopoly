class ActivitiesController < ApplicationController
  before_filter :prepare_params
  
  def earn
    params[:report].delete(:type)
    
    @business.reports.create(params[:report])
    @account.reports.create(params[:report])
    @place.reports.create(params[:report])
    
    @report.activity_type = "earn"
    if @report.save
      respond_to do |format|
        format.html { render :text => "Forbidden", :status => :forbidden }
        format.xml { render :nothing => true, :status => :ok }
        format.json { render :nothing => true, :status => :ok }
      end
    end
  end
  
  def spend
    params[:report].delete(:type)
    
    @business.reports.create(params[:report])
    @account.reports.create(params[:report])
    @place.reports.create(params[:report])
    
    @report.activity_type = "spend"
    if @report.save
      respond_to do |format|
        format.html { render :text => "Forbidden", :status => :forbidden }
        format.xml { render :nothing => true, :status => :ok }
        format.json { render :nothing => true, :status => :ok }
      end
    end
  end
  
  private
  def prepare_params
    business_id = params[:report].delete(:business_id)
    place_id = params[:report].delete(:place_id)
    
    @business = Business.where(business_id)
    @account  = Account.where(params[:report][:account_id])
    @place    = Place.where(place_id)
  end
end