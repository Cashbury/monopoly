class UsersSnapsController < ApplicationController
	before_filter :authenticate_user!,:require_admin
	
  def index
		@business_id = params[:business_id].to_i.zero? ? nil : params[:business_id].to_i
		@place_id = params[:place_id].to_i.zero? ? nil : params[:place_id].to_i
		@start_date=params[:start_date].to_i.zero? ? nil : params[:start_date]
		@end_date=params[:end_date].to_i.zero? ? nil : params[:end_date]
		@page = params[:page].to_i.zero? ? 1 : params[:page].to_i
		@results=UsersSnap.search :business_id => @business_id,
														  :place_id    => @place_id,
                              :start_date  => @start_date,
                              :end_date    => @end_date,
														  :page        => @page
  end
  
end
