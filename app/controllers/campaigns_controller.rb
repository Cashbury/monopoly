class CampaignsController < ApplicationController
  
  def index
    @campaigns = Campaign.all
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @campaigns }
      format.json { render :text => @campaigns.to_json }
    end
  end
end
