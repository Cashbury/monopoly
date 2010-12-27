class CampaignsController < ApplicationController
  
  def index
    @campaigns = Campaign.all
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @campaigns.to_xml(:include => [:businesses, :engagements, :rewards]) }
      format.json { render :json => @campaigns.to_json(:include => [:businesses, :engagements, :rewards]) }
    end
  end
end
