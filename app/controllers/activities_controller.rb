class ActivitiesController < ApplicationController
  def checkin
    params[:report].delete(:type)
    
    @report = Report.new(params[:report])
    @report.activity_type = "checkin"
    if @report.save
      respond_to do |format|
        format.html { render :text => "Forbidden", :status => :forbidden }
        format.xml { render :nothing => true, :status => :ok }
        format.json { render :nothing => true, :status => :ok }
      end
    end
  end
  
  def redeem
    params[:report].delete(:type)
    
    @report = Report.new(params[:report])
    @report.activity_type = "redeem"
    if @report.save
      respond_to do |format|
        format.html { render :text => "Forbidden", :status => :forbidden }
        format.xml { render :nothing => true, :status => :ok }
        format.json { render :nothing => true, :status => :ok }
      end
    end
end