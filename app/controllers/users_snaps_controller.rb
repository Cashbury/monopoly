class UsersSnapsController < ApplicationController
  before_filter :authenticate_user!, :require_admin
  def index
		@business_id = params[:business_id].to_i.zero? ? nil : params[:business_id].to_i
		@place_id = params[:place_id].to_i.zero? ? nil : params[:place_id].to_i
		@from_date=params[:from_date].to_i.zero? ? nil : params[:from_date]
		@to_date=params[:to_date].to_i.zero? ? nil : params[:to_date]
		@page = params[:page].to_i.zero? ? 1 : params[:page].to_i
		@results=Log.search :business_id => @business_id,
												:place_id    => @place_id,
                        :from_date   => @from_date,
                        :to_date     => @to_date,
											  :page        => @page,
												:type        =>Log::SEARCH_TYPES[:engagements]
  end

  def update_user
    @user = User.where(:id=>params[:id]).select("id,email, is_fb_enabled,telephone_number").first
    if @user.present?
      if params[:status].downcase == "off"
        @user.is_fb_enabled=false
      else
        @user.is_fb_enabled=true
      end
    end
    @user.save!
    respond_to do |f|
      f.html { redirect_to :controller=>"users_management", :action=>"show", :id=>@user.id}
      f.xml  { render :xml=>@user}
    end
  end

end
