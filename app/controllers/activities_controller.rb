class ActivitiesController < ApplicationController
  def create
    @activity = Activity.create(params[:activity])
    # if @activity.save
    #   redirect_to @activity
    # else
    #   render :action => 'new'
    # end
    respond_to do |format|
      format.html { render :text => "Forbidden", :status => :forbidden }
      format.xml { render :xml => @activity }
      format.json { render :text => @activity.to_json }
    end
  end
end